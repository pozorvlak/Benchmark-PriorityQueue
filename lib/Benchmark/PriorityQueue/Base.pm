package Benchmark::PriorityQueue::Base;
use Moose::Role;

use 5.10.0;

use Carp;
use Benchmark qw/:all/;
use DateTime;

has 'timeout' => (is => 'rw', isa => 'DateTime::Duration');
requires 'middles';

sub insert_n_random {
	my ($self, $n) = @_;
	my $l = $self->new_queue();
	for my $i (1 .. $n) {
		$self->insert($l, $i, rand());
	}
	return $l;
}

sub insert_n_ordered {
	my ($self, $n) = @_;
	my $l = $self->new_queue();
	for my $i (1 .. $n) {
		$self->insert($l, $i, $i);
	}
	return $l;
}

sub insert_n_random_mod3 {
	my ($self, $n) = @_;
	my $l = $self->new_queue();
	for my $i (1 .. $n) {
		$self->insert($l, $i, int(rand(3)));
	}
	return $l;
}

sub insert_n_ordered_mod3 {
	my ($self, $n) = @_;
	my $l = $self->new_queue();
	for my $i (1 .. $n) {
		$self->insert($l, $i, $i % 3);
	}
	return $l;
}

sub setups {
	my ($self) = @_;
	return (
		ordered_mod3	=> \&insert_n_ordered_mod3,
		random_mod3		=> \&insert_n_random_mod3,
		ordered			=> \&insert_n_ordered,
		random			=> \&insert_n_random,
	);
}

# Given a setup function and some code to time, make a benchmarking sub.
sub make_benchmark {
	my ($self, $setup, $middle) = @_;
	return sub {
		my @args = $setup->(@_);
		return timeit(10, sub {
			$middle->(@args);
		});
	};
}

# Identity function; serves as setup for benchmarks which are themselves
# setup functions.
sub id {
	return @_;
}

sub benchmark_code {
	my ($self) = @_;
	my %setups = $self->setups();
	my %middles = $self->middles();
	my %supported;
	for my $setup (keys %setups) {
		for my $middle (keys %middles) {
			$supported{"${middle}_$setup"} =
				$self->make_benchmark($setups{$setup}, $middles{$middle});
		}
		$supported{"setup_$setup"} = $self->make_benchmark(\&id, $setups{$setup});
	}
	return %supported;
}

sub supported {
	my ($self) = @_;
	my %bmarks = $self->benchmark_code;
	return keys %bmarks;
}

sub supports {
	my ($self, $bmark) = @_;
	my %bmarks = $self->benchmark_code;
	return exists $bmarks{$bmark};
}

sub timed_out {
	my ($self, $start_time) = @_;
	my $timeout = $self->timeout;
	if ($timeout->seconds > 0) {
		return $start_time + $timeout < DateTime->now();
	}
	return 0;
}

sub run_benchmark {
	my ($self, $bmark, $max_n) = @_;
	my %bmarks = $self->benchmark_code();
	my $f = $bmarks{$bmark};
	my @results;
	my $start_time = DateTime->now();
	for my $n (1 .. $max_n) {
		push @results, $f->($self, 10**$n);
		last if $self->timed_out($start_time);
	}
	return @results;
}

sub print_benchmark {
	local $| = 1;
	my ($self, $bmark, $max_n) = @_;
	my %bmarks = $self->benchmark_code();
	my $f = $bmarks{$bmark};
	my $start_time = DateTime->now();
	for my $n (1 .. $max_n) {
		my @time = @{$f->($self, 10**$n)};
		print $time[1] + $time[2];
		last if $self->timed_out($start_time);
		print ", " unless $n == $max_n;
	}
	print "\n";
	return 1;
}

1;

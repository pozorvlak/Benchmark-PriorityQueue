package Benchmark::PriorityQueue::Base;
use Moose;

use 5.10.0;

use Carp;
use Benchmark qw/timeit/;
use DateTime;

has 'timeout' => (is => 'rw', isa => 'DateTime::Duration');

sub random_insert {
	my ($self, $n) = @_;
	my $l = $self->new_queue();
	return timeit(10, sub {
		$self->insert_n_random($l, $n);
	});
}

sub ordered_insert {
	my ($self, $n) = @_;
	my $l = $self->new_queue();
		return timeit(10, sub {
		$self->insert_n_ordered($l, $n);
	});
}

sub random_insert_mod3 {
	my ($self, $n) = @_;
	my $l = $self->new_queue();
	return timeit(10, sub {
		$self->insert_n_random_mod3($l, $n);
	});
}

sub ordered_insert_mod3 {
	my ($self, $n) = @_;
	my $l = $self->new_queue();
		return timeit(10, sub {
		$self->insert_n_ordered_mod3($l, $n);
	});
}

sub insert_n_random {
	my ($self, $l, $n) = @_;
	for my $i (1 .. $n) {
		$self->insert($l, $i, rand());
	}
}

sub insert_n_ordered {
	my ($self, $l, $n) = @_;
	for my $i (1 .. $n) {
		$self->insert($l, $i, $i);
	}
}

sub insert_n_random_mod3 {
	my ($self, $l, $n) = @_;
	for my $i (1 .. $n) {
		$self->insert($l, $i, int(rand(3)));
	}
}

sub insert_n_ordered_mod3 {
	my ($self, $l, $n) = @_;
	for my $i (1 .. $n) {
		$self->insert($l, $i, $i % 3);
	}
}

sub pop_highest_ordered {
	my ($self, $n) = @_;
	my $l = $self->new_queue();
	$self->insert_n_ordered($l, $n);
	return timeit(10, sub {
		$self->pop_highest($l);
	});
}

sub pop_highest_ordered_mod3 {
	my ($self, $n) = @_;
	my $l = $self->new_queue();
	$self->insert_n_ordered_mod3($l, $n);
	return timeit(10, sub {
		$self->pop_highest($l);
	});
}

sub pop_highest_random {
	my ($self, $n) = @_;
	my $l = $self->new_queue();
	$self->insert_n_random($l, $n);
	return timeit(10, sub {
		$self->pop_highest($l);
	});
}

sub pop_highest_random_mod3 {
	my ($self, $n) = @_;
	my $l = $self->new_queue();
	$self->insert_n_random_mod3($l, $n);
	return timeit(10, sub {
		$self->pop_highest($l);
	});
}

sub benchmark_code {
	my ($self) = @_;
	my %supported = (
		'random_insert' => \&random_insert,
		'ordered_insert' => \&ordered_insert,
		'random_insert_mod3' => \&random_insert_mod3,
		'ordered_insert_mod3' => \&ordered_insert_mod3,
	);
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

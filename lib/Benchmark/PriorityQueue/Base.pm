package Benchmark::PriorityQueue::Base;

use strict;
use warnings;
use 5.10.0;

use Carp;
use Benchmark qw/:all/;

sub new {
        my $this = shift;
        my $class = ref($this) || $this;
        my $self = {};
        bless $self, $class;
	return $self;
}

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

sub pop_lowest_n {
	my ($self, $l, $n) = @_;
	for my $i (1 .. $n) {
		$self->pop_lowest($l);
	}
}

sub pop_highest_n {
	my ($self, $l, $n) = @_;
	for my $i (1 .. $n) {
		$self->pop_highest($l);
	}
}

sub pop_highest_ordered {
	my ($self, $n) = @_;
	my $l = $self->new_queue();
	$self->insert_n_ordered($l, $n);
	return timeit(10, sub {
		$self->pop_highest_n($l, $n);
	});
}

sub pop_lowest_ordered {
	my ($self, $n) = @_;
	my $l = $self->new_queue();
	$self->insert_n_ordered($l, $n);
	return timeit(10, sub {
		$self->pop_lowest_n($l, $n);
	});
}

sub pop_highest_random {
	my ($self, $n) = @_;
	my $l = $self->new_queue();
	$self->insert_n_random($l, $n);
	return timeit(10, sub {
		$self->pop_highest_n($l, $n);
	});
}

sub pop_lowest_random {
	my ($self, $n) = @_;
	my $l = $self->new_queue();
	$self->insert_n_random($l, $n);
	return timeit(10, sub {
		$self->pop_lowest_n($l, $n);
	});
}

sub benchmark_code {
	my ($self) = @_;
	my %supported = (
		'random_insert' => \&random_insert,
		'ordered_insert' => \&ordered_insert,
	);
	if ($self->can("pop_highest")) {
		$supported{pop_highest_ordered} = \&pop_highest_ordered;
		$supported{pop_highest_random} = \&pop_highest_random;
	}
	if ($self->can("pop_lowest")) {
		$supported{pop_lowest_ordered} = \&pop_lowest_ordered;
		$supported{pop_lowest_random} = \&pop_lowest_random;
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

sub run_benchmark {
	my ($self, $bmark, $max_n) = @_;
	my %bmarks = $self->benchmark_code();
	my $f = $bmarks{$bmark};
	my @results;
	for my $n (1 .. $max_n) {
		push @results, $f->($self, 10**$n);
	}
	return @results;
}

sub print_benchmark {
	my ($self, $bmark, $n) = @_;
	my @times = map { $_->[1] + $_->[2] } $self->run_benchmark($bmark, $n);
	say join(", ", @times);
	return 1;
}

sub new_queue {
	croak "new_queue should return a new priority queue";
}

sub module_tested {
	croak "module_tested should return the name of the module under test.";
}

1;

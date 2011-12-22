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
		for my $i (1 .. $n) {
			$self->insert($l, $i, rand());
		}
	});
}

sub ordered_insert {
	my ($self, $n) = @_;
	my $l = $self->new_queue();
		return timeit(10, sub {
		for my $i (1 .. $n) {
			$self->insert($l, $i, $i);
		}
	});
}

sub supported {
	return (
		'random_insert' => \&random_insert,
		'ordered_insert' => \&ordered_insert,
	);
}

sub new_queue {
	croak "new_queue should return a new priority queue";
}

sub module_tested {
	croak "module_tested should return the name of the module under test.";
}

1;

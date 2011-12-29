package Benchmark::PriorityQueue::PopsLowest;
use Moose::Role;
use Benchmark qw/timeit/;

requires 'pop_lowest';

sub middles {
	return ( pop_lowest => \&pop_lowest );
}

1;

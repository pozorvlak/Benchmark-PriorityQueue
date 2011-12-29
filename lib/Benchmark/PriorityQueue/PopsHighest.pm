package Benchmark::PriorityQueue::PopsHighest;
use Moose::Role;
use Benchmark qw/timeit/;

requires 'pop_highest';

sub middles {
	return ( pop_highest => \&pop_highest );
}

1;

package Benchmark::PriorityQueue::PopsHighest;
use Moose::Role;
use Benchmark qw/timeit/;

requires 'pop_highest';

around 'benchmark_code' => sub {
	my ($orig, $self) = @_;
	my %supported = $self->$orig();
	$supported{pop_highest_ordered} = \&pop_highest_ordered;
	$supported{pop_highest_random} = \&pop_highest_random;
	return %supported;
};

sub pop_highest_random {
	my ($self, $n) = @_;
	my $l = $self->new_queue();
	$self->insert_n_random($l, $n);
	return timeit(10, sub {
		$self->pop_highest($l);
	});
}

sub pop_highest_ordered {
	my ($self, $n) = @_;
	my $l = $self->new_queue();
	$self->insert_n_ordered($l, $n);
	return timeit(10, sub {
		$self->pop_highest($l);
	});
}

1;

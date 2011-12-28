package Benchmark::PriorityQueue::PopsLowest;
use Moose::Role;
use Benchmark qw/timeit/;

requires 'pop_lowest';

around 'benchmark_code' => sub {
	my ($orig, $self) = @_;
	my %supported = $self->$orig();
	$supported{pop_lowest_ordered} = \&pop_lowest_ordered;
	$supported{pop_lowest_random} = \&pop_lowest_random;
	return %supported;
};

sub pop_lowest_random {
	my ($self, $n) = @_;
	my $l = $self->new_queue();
	$self->insert_n_random($l, $n);
	return timeit(10, sub {
		$self->pop_lowest_n($l, 1);
	});
}

sub pop_lowest_ordered {
	my ($self, $n) = @_;
	my $l = $self->new_queue();
	$self->insert_n_ordered($l, $n);
	return timeit(10, sub {
		$self->pop_lowest_n($l, 1);
	});
}

sub pop_lowest_n {
	my ($self, $l, $n) = @_;
	for my $i (1 .. $n) {
		$self->pop_lowest($l);
	}
}

1;

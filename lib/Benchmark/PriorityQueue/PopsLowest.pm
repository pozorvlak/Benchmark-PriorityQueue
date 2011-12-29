package Benchmark::PriorityQueue::PopsLowest;
use Moose::Role;

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
	return $self->time_method(pop_lowest => sub {
		$self->insert_n_random(@_, $n);
	});
}

sub pop_lowest_ordered {
	my ($self, $n) = @_;
	return $self->time_method(pop_lowest => sub {
		$self->insert_n_ordered(@_, $n);
	});
}

1;

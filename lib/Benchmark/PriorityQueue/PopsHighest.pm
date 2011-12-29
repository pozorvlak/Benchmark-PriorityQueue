package Benchmark::PriorityQueue::PopsHighest;
use Moose::Role;

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
	return $self->time_method(pop_highest => sub {
		$self->insert_n_random(@_, $n);
	});
}

sub pop_highest_ordered {
	my ($self, $n) = @_;
	return $self->time_method(pop_highest => sub {
		$self->insert_n_ordered(@_, $n);
	});
}

1;

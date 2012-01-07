package Benchmark::PriorityQueue::PopsLowest;
use Moose::Role;

requires 'pop_lowest';

around 'task_code' => sub {
	my ($orig, $self) = @_;
	my %supported = (
		$self->$orig(),
		pop_lowest_ordered      => \&pop_lowest_ordered,
		pop_lowest_ordered_mod3 => \&pop_lowest_ordered_mod3,
		pop_lowest_random       => \&pop_lowest_random,
		pop_lowest_random_mod3  => \&pop_lowest_random_mod3,
	);
	return %supported;
};

sub pop_lowest_random {
	my ($self, $rank) = @_;
	return $self->time_method(pop_lowest => sub {
		$self->insert_n_random(@_, $rank);
	});
}

sub pop_lowest_ordered {
	my ($self, $rank) = @_;
	return $self->time_method(pop_lowest => sub {
		$self->insert_n_ordered(@_, $rank);
	});
}

sub pop_lowest_ordered_mod3 {
	my ($self, $rank) = @_;
	return $self->time_method(pop_lowest => sub {
		$self->insert_n_ordered_mod3(@_, $rank);
	});
}

sub pop_lowest_random_mod3 {
	my ($self, $rank) = @_;
	return $self->time_method(pop_lowest => sub {
		$self->insert_n_random_mod3(@_, $rank);
	});
}

1;

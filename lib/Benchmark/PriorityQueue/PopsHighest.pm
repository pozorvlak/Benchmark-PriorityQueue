package Benchmark::PriorityQueue::PopsHighest;
use Moose::Role;

requires 'pop_highest';

around 'task_code' => sub {
	my ($orig, $self) = @_;
	my %supported = (
		$self->$orig,
		pop_highest_ordered      => \&pop_highest_ordered,
		pop_highest_ordered_mod3 => \&pop_highest_ordered_mod3,
		pop_highest_random       => \&pop_highest_random,
		pop_highest_random_mod3  => \&pop_highest_random_mod3,
	);
	return %supported;
};

sub pop_highest_random {
	my ($self, $rank) = @_;
	return $self->time_method(pop_highest => sub {
		$self->insert_n_random(@_, $rank);
	});
}

sub pop_highest_ordered {
	my ($self, $rank) = @_;
	return $self->time_method(pop_highest => sub {
		$self->insert_n_ordered(@_, $rank);
	});
}

sub pop_highest_ordered_mod3 {
	my ($self, $rank) = @_;
	return $self->time_method(pop_highest => sub {
		$self->insert_n_ordered_mod3(@_, $rank);
	});
}

sub pop_highest_random_mod3 {
	my ($self, $rank) = @_;
	return $self->time_method(pop_highest => sub {
		$self->insert_n_random_mod3(@_, $rank);
	});
}

1;

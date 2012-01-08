package Benchmark::PriorityQueue::Shim;
use Moose::Role;

use 5.10.0;

use namespace::autoclean;
use Benchmark qw/timeit countit/;

requires qw<new_queue backend insert>;

has iterations => (is => 'ro', isa => 'Int', default => 10);

sub time_method {
	my ($self, $method, @args) = @_;
	my $l = $self->new_queue;
	# Optional trailing coderef to set up the list for this test;
	# receives $l as its sole argument
	if (@args && ref $args[-1] eq 'CODE') {
		my $setup = pop @args;
		$setup->($l);
	}
	my $code_to_time = sub { $self->$method($l, @args) };
	if ($self->iterations < 0) {
		return countit(-$self->iterations, $code_to_time);
	}
	else {
		return timeit(  $self->iterations, $code_to_time);
	}
}

sub random_insert {
	my ($self, $rank) = @_;
	return $self->time_method(insert_n_random => $rank);
}

sub ordered_insert {
	my ($self, $rank) = @_;
	return $self->time_method(insert_n_ordered => $rank);
}

sub random_insert_mod3 {
	my ($self, $rank) = @_;
	return $self->time_method(insert_n_random_mod3 => $rank);
}

sub ordered_insert_mod3 {
	my ($self, $rank) = @_;
	return $self->time_method(insert_n_ordered_mod3 => $rank);
}

sub insert_n_random {
	my ($self, $l, $rank) = @_;
	for my $i (1 .. $rank) {
		$self->insert($l, $i, rand());
	}
}

sub insert_n_ordered {
	my ($self, $l, $rank) = @_;
	for my $i (1 .. $rank) {
		$self->insert($l, $i, $i);
	}
}

sub insert_n_random_mod3 {
	my ($self, $l, $rank) = @_;
	for my $i (1 .. $rank) {
		$self->insert($l, $i, int(rand(3)));
	}
}

sub insert_n_ordered_mod3 {
	my ($self, $l, $rank) = @_;
	for my $i (1 .. $rank) {
		$self->insert($l, $i, $i % 3);
	}
}

sub task_code {
	my ($self) = @_;
	my %supported = (
		'random_insert' => \&random_insert,
		'ordered_insert' => \&ordered_insert,
		'random_insert_mod3' => \&random_insert_mod3,
		'ordered_insert_mod3' => \&ordered_insert_mod3,
	);
	return %supported;
}

sub supported {
	my ($self) = @_;
	my %tasks = $self->task_code;
	return keys %tasks;
}

sub supports {
	my ($self, $task) = @_;
	my %tasks = $self->task_code;
	return exists $tasks{$task};
}

sub time_workload {
	my ($self, $task, $rank) = @_;
	my %tasks = $self->task_code();
	return $tasks{$task}->($self, $rank);
}

1;

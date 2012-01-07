package Benchmark::PriorityQueue::Shim;
use Moose::Role;

use 5.10.0;

use namespace::autoclean;
use Benchmark qw/timeit countit/;
use DateTime;

requires qw<new_queue backend insert>;

has 'timeout' => (is => 'rw', isa => 'DateTime::Duration');
has 'iterations' => (is => 'rw', isa => 'Int', default => 10);

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

sub timed_out {
	my ($self, $start_time) = @_;
	my $timeout = $self->timeout;
	if ($timeout->seconds > 0) {
		return $start_time + $timeout < DateTime->now();
	}
	return 0;
}

sub run_workload {
	my ($self, $task, $max_rank_exponent) = @_;
	my %tasks = $self->task_code();
	my $f = $tasks{$task};
	my @results;
	my $start_time = DateTime->now();
	for my $rank_exponent (1 .. $max_rank_exponent) {
		push @results, $f->($self, 10**$rank_exponent);
		last if $self->timed_out($start_time);
	}
	return @results;
}

sub print_benchmark {
	local $| = 1;
	my ($self, $task, $max_rank_exponent) = @_;
	my $start_time = DateTime->now();
	for my $rank_exponent (1 .. $max_rank_exponent) {
		my @time = @{ $self->time_workload($task, 10**$rank_exponent) };
		print $time[1] + $time[2];
		last if $self->timed_out($start_time);
		print ", " if $rank_exponent < $max_rank_exponent;
	}
	print "\n";
	return 1;
}

sub time_workload {
	my ($self, $task, $rank) = @_;
	my %tasks = $self->task_code();
	return $tasks{$task}->($self, $rank);
}

1;

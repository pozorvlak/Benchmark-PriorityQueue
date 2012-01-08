package Benchmark::PriorityQueue;

use 5.010000;
use strict;
use warnings;
use Benchmark::PriorityQueue::Result;
use List::MoreUtils qw(uniq);
use Module::Load qw(load);
use Sys::SigAction qw(timeout_call);

use Exporter qw(import);
our @EXPORT_OK = qw(run_workloads all_tasks all_backends make_shim);

our $VERSION = '0.01';

my @backends = qw(
	List::Priority
	List::PriorityQueue
	Hash::PriorityQueue
	Heap::Priority
	Data::PrioQ::SkewBinomial
	POE::Queue::Array
	POE::XS::Queue::Array
);

for my $backend (@backends) {
	load "Benchmark::PriorityQueue::$backend";
}

sub make_shim {
	my ($backend, @constructor_args) = @_;
	my $shim_class = "Benchmark::PriorityQueue::$backend";
	return $shim_class->new(@constructor_args);
}

sub all_backends {
	return sort @backends;
}

sub all_tasks {
	return sort +uniq(map { make_shim($_)->supported } @backends);
}

sub with_timeout {
	my ($timeout, $body) = @_;
	return $body->() if !defined $timeout;
	timeout_call($timeout, $body);
}

sub run_workloads {
	my (%args) = @_;

	$args{tasks}    ||= [all_tasks()];
	$args{backends} ||= [all_backends()];
	$args{ranks}    ||= [1000];

	my @shims = map { make_shim($_) } @{ $args{backends} };

	my @ret;
	for my $task (@{ $args{tasks} }) {
		for my $shim (@shims) {
			next if !$shim->supports($task);
			with_timeout($args{timeout}, sub {
				for my $rank (@{ $args{ranks} }) {
					my $results = $shim->time_workload($task, $rank);
					push @ret, Benchmark::PriorityQueue::Result->new(
						task    => $task,
						backend => $shim->backend,
						rank    => $rank,
						results => $results,
					);
				}
			});
		}
	}

	return @ret;
}

1;
__END__

=head1 NAME

Benchmark::PriorityQueue - Perl extension for benchmarking priority queues.

=head1 SYNOPSIS

  use Benchmark::PriorityQueue qw/all_tasks all_backends/;

  # All task names
  my @tasks = all_tasks();

  # The names of all underlying priority-queue modules tested
  my @backends = all_backends();

  # Benchmark ALL THE TASKS
  my @results = run_workloads(
      ranks   => [map { 10**$_ } 1 .. 6],
      timeout => $timeout,
  );

=head1 DESCRIPTION

As of December 2011, there were approximately thirty kajillion priority queue
modules(*) on CPAN. They are not all equally well-written; moreover, there are
several possible ways of implementing priority queues, and they have different
performance characteristics. This module is intended to help you choose the
right one for I<your> application.

(*) OK, seven.

=head2 FUNCTIONS

=over 4

=item C<all_backends()>

Returns a list of all known backend module names.

=item C<all_tasks()>

Returns a list of all known task names.

=item C<make_shim($backend, @args)>

Create and return an instance of the shim class for the given C<$backend>.
Any additional C<@args> are passed directly to the appropriate constructor.

=item C<run_workloads(%args)>

Run all workloads indicated by the C<%args>, and return a list of
L<Benchmark::PriorityQueue::Result> objects with the results for each
workload run.  Elements of C<%args> can be:

=over 4

=item C<tasks>

An array ref of task names to execute; defaults to all known tasks if the
value is false (but not if you supply an empty array ref).

=item C<backends>

An array ref of backend module names to benchmark; defaults to all known
backends if the value is false (but not if you supply an empty array ref).

=item C<ranks>

An array ref of rank values to use; defaults to a singleton array containing
1000 if the value is false (but not if you supply an empty array ref).

=item C<timeout>

Maximum number of seconds to run a given B<benchmark> on; if missing or
undefined, there is no time limit.  If the timeout is exceeded,
C<run_workloads()> silently gives up and attempts the next B<benchmark>.

Note that if the first rank for a given benchmark takes longer than the
timeout, you won't get any results for that benchmark.

=back

=back

=head2 EXPORT

None by default.

=head2 GLOSSARY

=over 4

=item B<backend>

A CPAN module whose performance is to be investigated.  Examples:
C<List::Priority>, C<POE::Queue::Array>.

=item B<shim>

A class which performs the C<Benchmark::PriorityQueue::Shim> role, or an
instance of such a class; shims exist to provide a consistent API over all
the B<backends> under consideration.  Examples:
C<Benchmark::PriorityQueue::List::Priority>,
C<Benchmark::PriorityQueue::POE::Queue::Array>.

=item B<task>

A named sequence of actions which can be executed on some B<shim>.  Note
that more information than a task's name is needed for actually timing a
piece of code; see B<workload> and B<benchmark> below.  Examples:
C<ordered_insert>, C<pop_lowest_random>.

We say that a given B<shim> may B<support> a particular task.

Each task is implemented by a method of the same name in a B<shim> class
(typically composed from a role like C<Benchmark::PriorityQueue::Shim>).

=item B<benchmark>

A pair of a B<task> and a B<backend>; the backend will B<support> the task.
For example, (C<random_insert>, C<List::Priority>) is a benchmark for doing
random insertions (of some B<rank>) using C<List::Priority>.

=item B<workload>

A triple of a B<task>, a B<backend>, and a B<rank> (where the B<rank> is an
integer whose interpretation depends on the task); alternatively, it can be
considered a pair of a B<benchmark> and a B<rank>.  A workload is the
smallest thing that can be executed with no other information.  For example,
(C<random_insert>, C<List::Priority>, 1e5) will measure how long it takes to
insert 100,000 random values into a C<List::Priority>.

=back

=head1 SEE ALSO

L<Heap::Priority>, L<List::Priority>, L<List::PriorityQueue>,
L<Hash::PriorityQueue>, L<POE::Queue>, L<Timeout::Queue>,
L<Data::PrioQ::SkewBinomial>.

=head1 CONTRIBUTING

The version control repository for this distribution may be found at
L<http://github.com/pozorvlak/Benchmark-PriorityQueue>. The best way to
contribute to this module is with the standard GitHub pull request system.

=head1 AUTHOR

Miles Gould, E<lt>miles@assyrian.org.ukE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Miles Gould

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.12.4 or,
at your option, any later version of Perl 5 you may have available.

=cut

package Benchmark::PriorityQueue::Result;
use Moose;

use Benchmark ();

has task       => (is => 'ro', isa => 'Str', required => 1);
has backend    => (is => 'ro', isa => 'Str', required => 1);
has rank       => (is => 'ro', isa => 'Int', required => 1);
has results    => (is => 'ro', isa => 'Benchmark', required => 1);

has @$_, is => 'ro', init_arg => undef, lazy => 1, builder => "_build_$_->[0]"
    for ([seconds         => (isa => 'Num')], # user + sys
         [iterations      => (isa => 'Int')], # iterations actually run
         [backend_version => (isa => 'Str')]);

sub _build_seconds         { $_[0]->results->[1] + $_[0]->results->[2] }
sub _build_iterations      { $_[0]->results->[5] }
sub _build_backend_version { $_[0]->backend->VERSION }

1;
__END__

=head1 NAME

Benchmark::PriorityQueue::Result - results of a single priority-queue benchmark workload

=head1 METHODS

=head2 C<new> constructor

Four named attributes are accepted, and all are required.

=over 4

=item C<backend>

The name of the backend module being benchmarked.

=item C<rank>

The rank of the workload that was run.

=item C<task>

The name of the task that was run.

=item C<results>

A C<Benchmark> object with the relevant timing details.

=back

=head2 C<backend()>

Returns the name of the backend module that was benchmarked.

=head2 C<backend_version()>

Returns the version number reported by the backend module that was
benchmarked.

=head2 C<iterations()>

Returns the number of iterations run to benchmark this workload.  (Note that
the C<iterations> attribute for a C<Benchmark::PriorityQueue::Shim> object
can indicate the maximum I<time> to run for, rather than an actual iteration
count, so this information isn't necessarily available in any other way.)

=head2 C<rank()>

Returns the rank of the workload that was run.

=head2 C<results()>

Returns a C<Benchmark> object with the relevant timing details.

=head2 C<seconds()>

Returns the number of seconds taken to run this workload.  Calculated as the
sum of the user and system times measured by C<< $self->results >>.

=head2 C<task()>

Returns the name of the task that was run.

=cut

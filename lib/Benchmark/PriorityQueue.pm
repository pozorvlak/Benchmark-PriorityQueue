package Benchmark::PriorityQueue;

use 5.010000;
use strict;
use warnings;
use Benchmark qw/:all/;

require Exporter;

our @ISA = qw(Exporter);

our @EXPORT_OK = qw(run_all_benchmarks);

our $VERSION = '0.01';

use Benchmark::PriorityQueue::List::Priority;

sub run_benchmark {
	my ($max_n, $f) = @_;
	my @results;
	for my $n (1 .. $max_n) {
		push @results, $f->(10**$n);
	}
	return @results;
}

sub print_benchmark {
	say join(", ", map { $_->[1] + $_->[2] } run_benchmark(@_));
	return 1;
}

sub run_all_benchmarks {
	my $n = shift // 6;
	my %bplp = Benchmark::PriorityQueue::List::Priority::supported();
	my $benchmarks_run = 0;
	for my $bmark (keys %bplp) {
		print "$bmark, ";
		$benchmarks_run += print_benchmark($n, $bplp{$bmark});
	}
	return $benchmarks_run;
}

1;
__END__

=head1 NAME

Benchmark::PriorityQueue - Perl extension for benchmarking priority queues.

=head1 SYNOPSIS

  use Benchmark::PriorityQueue qw/run_benchmarks run_all_benchmarks/;

  # Run only the benchmarks you care about
  run_benchmarks('random_insert', 'ordered_insert');

  # Benchmark ALL THE FEATURES
  run_all_benchmarks();

=head1 DESCRIPTION

As of December 2011, there were approximately thirty kajillion priority queue
modules(*) on CPAN. They are not all equally well-written; moreover, there are
several possible ways of implementing priority queues, and they have different
performance characteristics. This module is intended to help you choose the
right one for I<your> application.

(*) OK, seven.

=head2 EXPORT

None by default.

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

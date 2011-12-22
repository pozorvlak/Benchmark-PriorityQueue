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
use Benchmark::PriorityQueue::List::PriorityQueue;
use Benchmark::PriorityQueue::Heap::Priority;

our @test_modules = (
	Benchmark::PriorityQueue::List::Priority->new(),
	Benchmark::PriorityQueue::List::PriorityQueue->new(),
	# Benchmark::PriorityQueue::Heap::Priority->new(),
);

sub run_benchmark {
	my ($tester, $bmark, $max_n) = @_;
	my %bmarks = $tester->supported();
	my $f = $bmarks{$bmark};
	my @results;
	for my $n (1 .. $max_n) {
		push @results, $f->($tester, 10**$n);
	}
	return @results;
}

sub print_benchmark {
	say join(", ", map { $_->[1] + $_->[2] } run_benchmark(@_));
	return 1;
}

sub run_all_benchmarks {
	my $n = shift // 6;
	my $bmarks_run = 0;
	foreach my $tester (@test_modules) {
		say $tester->module_tested();
		my %bmarks = $tester->supported();
		for my $bmark (keys %bmarks) {
			print "$bmark, ";
			$bmarks_run += print_benchmark($tester, $bmark, $n);
		}
		say "";
	}
	return $bmarks_run;
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

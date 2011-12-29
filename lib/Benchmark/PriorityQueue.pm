package Benchmark::PriorityQueue;

use 5.010000;
use strict;
use warnings;
use Set::Scalar;

require Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(run_all_benchmarks run_benchmark);
our $VERSION = '0.01';

use Benchmark::PriorityQueue::List::Priority;
use Benchmark::PriorityQueue::List::PriorityQueue;
use Benchmark::PriorityQueue::Hash::PriorityQueue;
use Benchmark::PriorityQueue::Heap::Priority;
use Benchmark::PriorityQueue::Data::PrioQ::SkewBinomial;
use Benchmark::PriorityQueue::POE::Queue::Array;
use Benchmark::PriorityQueue::POE::XS::Queue::Array;

our @testers = (
	Benchmark::PriorityQueue::List::Priority->new(),
	Benchmark::PriorityQueue::List::PriorityQueue->new(),
	Benchmark::PriorityQueue::Hash::PriorityQueue->new(),
	Benchmark::PriorityQueue::Heap::Priority->new(),
	Benchmark::PriorityQueue::Data::PrioQ::SkewBinomial->new(),
	Benchmark::PriorityQueue::POE::Queue::Array->new(),
	Benchmark::PriorityQueue::POE::XS::Queue::Array->new(),
);

# Hash of [module name] => tester mappings
our %testers = map { $_->module_tested() => $_ } @testers;
# Names of all supported benchmarks

sub all_tested_modules {
	return sort(keys %testers);
}

sub all_benchmarks {
	my $benchmarks = Set::Scalar->new;
	$benchmarks->insert($_->supported) for @testers;
	return sort($benchmarks->members);
}

sub run_benchmark {
	my ($bmark, $n, $timeout, @modules_to_test) = @_;
	my $result;
	if (@modules_to_test == 0) {
		# If no modules specified, test them all.
		@modules_to_test = all_tested_modules;
	}
	say $bmark;
	for my $module (@modules_to_test) {
		my $tester = $testers{$module};
		$tester->timeout($timeout);
		die "No tester for $module" unless defined $tester;
		next unless $tester->supports($bmark);
		print $tester->module_tested(), ", ";
		$result = $tester->print_benchmark($bmark, $n);
	}
	say "";
	return $result;
}

sub run_all_benchmarks {
	my ($n, $timeout, @modules) = @_;
	my $bmarks_run = 0;
	foreach my $bmark (all_benchmarks()) {
		$bmarks_run += run_benchmark($bmark, $n, $timeout, @modules);
	}
	return $bmarks_run;
}

1;
__END__

=head1 NAME

Benchmark::PriorityQueue - Perl extension for benchmarking priority queues.

=head1 SYNOPSIS

  use Benchmark::PriorityQueue qw/run_benchmark run_all_benchmarks/;

  # Run only the benchmark you care about
  run_benchmark('random_insert', 6, "List::Priority", "Hash::PriorityQueue");

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

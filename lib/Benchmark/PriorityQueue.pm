package Benchmark::PriorityQueue;

use 5.010000;
use strict;
use warnings;
use List::MoreUtils qw(uniq);

use Exporter qw(import);
our @EXPORT_OK = qw(run_all_benchmarks run_benchmark);

our $VERSION = '0.01';

my @testees = qw(
	List::Priority
	List::PriorityQueue
	Hash::PriorityQueue
	Heap::Priority
	Data::PrioQ::SkewBinomial
	POE::Queue::Array
	POE::XS::Queue::Array
);

for my $module (@testees) {
	(my $file = $module) =~ s{::}{/}g;
	require "Benchmark/PriorityQueue/$file.pm";
}

my @testers = map { "Benchmark::PriorityQueue::$_"->new } @testees;

# Hash of [module name] => tester mappings
my %testers = map { $_->module_tested() => $_ } @testers;

sub module_is_tested {
	my ($module) = @_;
	return defined $testers{$module};
}

sub all_tested_modules {
	return sort(keys %testers);
}

sub all_benchmarks {
	return sort uniq(map { $_->supported } @testers);
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

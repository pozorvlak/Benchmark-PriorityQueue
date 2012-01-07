use Test::More 0.88;
use Benchmark::PriorityQueue::List::Priority;

my $shim = new_ok('Benchmark::PriorityQueue::List::Priority');
isa_ok($shim->time_workload(ordered_insert => 10), 'Benchmark',
	'time_workload return value');

done_testing;

use Test::More 0.88;
use Benchmark::PriorityQueue::List::Priority;

my $benchmarker = new_ok('Benchmark::PriorityQueue::List::Priority');
isa_ok($benchmarker->time_benchmark(ordered_insert => 10), 'Benchmark',
	'time_benchmark return value');

done_testing;

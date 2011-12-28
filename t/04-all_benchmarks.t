use Test::More;
use Benchmark::PriorityQueue;

ok(scalar(Benchmark::PriorityQueue::all_benchmarks) > 0,
	"More than zero benchmarks in list");

done_testing;

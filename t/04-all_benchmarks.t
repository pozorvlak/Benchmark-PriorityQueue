use Test::More;
use Benchmark::PriorityQueue;

my @benchmarks = Benchmark::PriorityQueue::all_benchmarks();
ok(@benchmarks > 0, "More than zero benchmarks in list");

done_testing;

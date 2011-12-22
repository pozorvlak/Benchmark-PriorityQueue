use Test::More;
use Benchmark::PriorityQueue 'run_all_benchmarks';

ok(run_all_benchmarks(1) > 0, "run_all_benchmarks completed successfully");

done_testing();


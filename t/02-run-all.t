use Test::More;
use Benchmark::PriorityQueue 'run_all_benchmarks';
use DateTime::Duration;

ok(run_all_benchmarks(1, DateTime::Duration->new(seconds => 7)) > 0,
	"run_all_benchmarks completed successfully");

done_testing();


use Test::More;
use Benchmark::PriorityQueue qw<run_workload all_tasks>;
use List::Util qw<sum>;
use DateTime::Duration;

my $timeout = DateTime::Duration->new(seconds => 7);
my $n_run = sum 0, map { run_workload($_, 1, $timeout) } all_tasks();

cmp_ok($n_run, '>', 0,
	"run_workload() on everything completed successfully");

done_testing();


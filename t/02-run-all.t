use Test::More;
use Benchmark::PriorityQueue qw<run_benchmark all_benchmarks>;
use List::Util qw<sum>;
use DateTime::Duration;

my $timeout = DateTime::Duration->new(seconds => 7);
my $n_run = sum 0, map { run_benchmark($_, 1, $timeout) } all_benchmarks();

cmp_ok($n_run, '>', 0,
	"run_benchmark() on everything completed successfully");

done_testing();


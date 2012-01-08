use Test::More;
use Benchmark::PriorityQueue qw<all_tasks>;

my @tasks = all_tasks();
ok(@tasks > 0, "More than zero tasks in list");

done_testing;

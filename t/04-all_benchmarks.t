use Test::More;
use Benchmark::PriorityQueue qw<all_benchmarks>;

my @benchmarks = all_benchmarks();
ok(@benchmarks > 0, "More than zero benchmarks in list");

done_testing;

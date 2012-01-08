use Test::More;
use Benchmark::PriorityQueue qw<run_workloads all_backends all_tasks>;

my @backends = all_backends();
my @tasks = all_tasks();

{
    my @results = run_workloads(ranks => [2, 2], timeout => 2);
    cmp_ok(scalar @results, '>=', scalar @tasks,
           'run_workloads() runs at least one backend+rank for each task');
    cmp_ok(scalar @results, '<=', @backends * @tasks * 2,
           'run_workloads() runs no more workloads than possible');
    isa_ok($results[$_], 'Benchmark::PriorityQueue::Result',
           "run_workloads() result $_")
        for 0 .. $#results;
}

{
    my @results = run_workloads(ranks => [], timeout => 2);
    is(scalar @results, 0,
       'run_workloads() does nothing when no ranks');
}

{
    my @results = run_workloads(ranks => [2], tasks => [], timeout => 2);
    is(scalar @results, 0,
       'run_workloads() does nothing when no tasks');
}

{
    my @results = run_workloads(ranks => [2], backends => [], timeout => 2);
    is(scalar @results, 0,
       'run_workloads() does nothing when no backends');
}

done_testing();

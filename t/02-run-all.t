use Test::More;
use Benchmark::PriorityQueue qw<run_workloads all_backends all_tasks>;

my @backends = all_backends();
my @tasks = all_tasks();

{
    my @results = run_workloads(ranks => [2, 2], timeout => 2, iterations => 1);
    cmp_ok(scalar @results, '>=', scalar @tasks,
           'run_workloads() runs at least one backend+rank for each task');
    cmp_ok(scalar @results, '<=', @backends * @tasks * 2,
           'run_workloads() runs no more workloads than possible');
    isa_ok($results[$_], 'Benchmark::PriorityQueue::Result',
           "run_workloads() result $_")
        for 0 .. $#results;
}

{
    my @results = run_workloads(ranks => [], timeout => 2, iterations => 1);
    is(scalar @results, 0,
       'run_workloads() does nothing when no ranks');
}

{
    my @results = run_workloads(ranks => [2], tasks => [], timeout => 2, iterations => 1);
    is(scalar @results, 0,
       'run_workloads() does nothing when no tasks');
}

{
    my @results = run_workloads(ranks => [2], backends => [], timeout => 2, iterations => 1);
    is(scalar @results, 0,
       'run_workloads() does nothing when no backends');
}

{
    my (@progress, @gathered);
    run_workloads(
        tasks    => [qw<random_insert random_insert_mod3>],
        backends => [qw<List::Priority List::PriorityQueue>],
        ranks    => [1, 2],
        progress => sub { push @progress, [@_] },
        gather   => sub {
            my ($task, @results) = @_;
            push @gathered, map { [$task, $_->backend, $_->rank] } @results;
        }
    );

    my @expected = (
        [random_insert      => 'List::Priority',      1],
        [random_insert      => 'List::Priority',      2],
        [random_insert      => 'List::PriorityQueue', 1],
        [random_insert      => 'List::PriorityQueue', 2],
        [random_insert_mod3 => 'List::Priority',      1],
        [random_insert_mod3 => 'List::Priority',      2],
        [random_insert_mod3 => 'List::PriorityQueue', 1],
        [random_insert_mod3 => 'List::PriorityQueue', 2],
    );
    is_deeply(\@progress, \@expected, "run_workloads() progress is as expected");
    is_deeply(\@gathered, \@expected, "run_workloads() gathered is as expected");
}

done_testing();

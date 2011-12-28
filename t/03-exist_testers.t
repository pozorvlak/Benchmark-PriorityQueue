use Test::More;
use Benchmark::PriorityQueue;

my @modules = qw/
	List::Priority
	List::PriorityQueue
	Hash::PriorityQueue
	Heap::Priority
	Data::PrioQ::SkewBinomial
	POE::Queue::Array
	POE::XS::Queue::Array
/;

for my $m (@modules) {
	ok(defined $Benchmark::PriorityQueue::testers{$m},
		"There's a test object for $m");
}

is_deeply([sort(@modules)],
	[sort(Benchmark::PriorityQueue::all_tested_modules())],
	"all_tested_modules returns expected result");

done_testing;

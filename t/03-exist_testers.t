use Test::More;
use Benchmark::PriorityQueue qw<all_tested_modules>;

my @modules = qw/
	List::Priority
	List::PriorityQueue
	Hash::PriorityQueue
	Heap::Priority
	Data::PrioQ::SkewBinomial
	POE::Queue::Array
	POE::XS::Queue::Array
/;

my @modules_found = all_tested_modules();

is_deeply([sort @modules], [sort @modules_found],
	"all_tested_modules returns expected result");

my %module_found = map { $_ => 1 } @modules_found;

for my $m (@modules) {
	ok($module_found{$m}, "There's a test object for $m");
}

done_testing;

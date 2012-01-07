use Test::More;
use Benchmark::PriorityQueue qw<all_backends>;

my @modules = qw/
	List::Priority
	List::PriorityQueue
	Hash::PriorityQueue
	Heap::Priority
	Data::PrioQ::SkewBinomial
	POE::Queue::Array
	POE::XS::Queue::Array
/;

my @modules_found = all_backends();

is_deeply([sort @modules], [sort @modules_found],
	"all_backends returns expected result");

my %module_found = map { $_ => 1 } @modules_found;

for my $m (@modules) {
	ok($module_found{$m}, "There's a backend for $m");
}

done_testing;

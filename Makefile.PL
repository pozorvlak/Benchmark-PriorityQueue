use 5.010000;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Benchmark::PriorityQueue',
    VERSION_FROM      => 'lib/Benchmark/PriorityQueue.pm', # finds $VERSION
    PREREQ_PM         => {
	'Moose' => 2.0401,
        'namespace::autoclean' => 0,
	'Test::More' => 0.88,
	'DateTime' => 0.70,
	'DateTime::Duration' => 0.70,
	'List::Util' => 0,
	'List::MoreUtils' => 0,
	'Heap::Priority' => 0.01,
	'List::Priority' => 0.03,
	'List::PriorityQueue' => 0.01,
	'Hash::PriorityQueue' => 0,
	'POE::Queue::Array' => 1.350,
	'POE::XS::Queue::Array' => 0,
	'Data::PrioQ::SkewBinomial' => 0.03
}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Benchmark/PriorityQueue.pm', # retrieve abstract from module
       AUTHOR         => 'Miles Gould <miles@assyrian.org.uk>') : ()),
);

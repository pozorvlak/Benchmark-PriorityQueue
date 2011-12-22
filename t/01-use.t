# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Benchmark-PriorityQueue.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use Test::More;
BEGIN { use_ok('Benchmark::PriorityQueue') };

done_testing;

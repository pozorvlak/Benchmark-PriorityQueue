package Benchmark::PriorityQueue::POE::XS::Queue::Array;

use strict;
use warnings;
use POE::XS::Queue::Array;
use parent 'Benchmark::PriorityQueue::Base';

sub new_queue {
	return POE::XS::Queue::Array->new();
}

sub insert {
	my ($self, $l, $obj, $priority) = @_;
	$l->enqueue($priority, $obj);
}

sub pop_highest {
	my ($self, $l) = @_;
	return $l->dequeue_next();
}

sub module_tested {
	return 'POE::XS::Queue::Array';
}

1;
__END__

=head1 NAME

Benchmark::PriorityQueue::POE::XS::Queue::Array - benchmark
POE::XS::Queue::Array.

=head1 SEE ALSO

L<Benchmark::PriorityQueue>, L<POE::XS::Queue::Array>.

=head1 AUTHOR

Miles Gould, E<lt>miles@assyrian.org.ukE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Miles Gould

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.12.4 or,
at your option, any later version of Perl 5 you may have available.

=cut

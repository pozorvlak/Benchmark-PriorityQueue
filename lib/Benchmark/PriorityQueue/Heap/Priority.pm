package Benchmark::PriorityQueue::Heap::Priority;
use Moose;

extends 'Benchmark::PriorityQueue::Base';
with 'Benchmark::PriorityQueue::PopsHighest';
with 'Benchmark::PriorityQueue::PopsLowest';

use Heap::Priority;

sub new_queue {
	return Heap::Priority->new();
}

sub insert {
	my ($self, $l, $object, $priority) = @_;
	$l->add($object, $priority);
}

sub pop_highest {
	my ($self, $l) = @_;
	$l->highest_first();
	return $l->pop();
}

sub pop_lowest {
	my ($self, $l) = @_;
	$l->lowest_first();
	return $l->pop();
}

sub module_tested {
	return 'Heap::Priority';
}

1;
__END__

=head1 NAME

Benchmark::PriorityQueue::Heap::Priority - benchmark Heap::Priority.

=head1 SEE ALSO

L<Benchmark::PriorityQueue>, L<Heap::Priority>.

=head1 AUTHOR

Miles Gould, E<lt>miles@assyrian.org.ukE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Miles Gould

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.12.4 or,
at your option, any later version of Perl 5 you may have available.

=cut

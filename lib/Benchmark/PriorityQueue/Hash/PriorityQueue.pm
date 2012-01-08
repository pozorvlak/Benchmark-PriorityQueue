package Benchmark::PriorityQueue::Hash::PriorityQueue;
use Moose;

with qw<Benchmark::PriorityQueue::Shim
        Benchmark::PriorityQueue::PopsLowest>;

use Hash::PriorityQueue;

sub new_queue {
	return Hash::PriorityQueue->new();
}

sub insert {
	my ($self, $l, $obj, $priority) = @_;
	$l->insert($obj, $priority);
}

sub pop_lowest {
	my ($self, $l) = @_;
	return $l->pop();
}

sub backend {
	return 'Hash::PriorityQueue';
}

1;
__END__

=head1 NAME

Benchmark::PriorityQueue::Hash::PriorityQueue - benchmark Hash::PriorityQueue.

=head1 SEE ALSO

L<Benchmark::PriorityQueue>, L<Hash::PriorityQueue>.

=head1 AUTHOR

Miles Gould, E<lt>miles@assyrian.org.ukE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Miles Gould

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.12.4 or,
at your option, any later version of Perl 5 you may have available.

=cut

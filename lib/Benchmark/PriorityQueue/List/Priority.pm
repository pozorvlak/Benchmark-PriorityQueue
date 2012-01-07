package Benchmark::PriorityQueue::List::Priority;
use Moose;

with qw<Benchmark::PriorityQueue::Shim
        Benchmark::PriorityQueue::PopsHighest
        Benchmark::PriorityQueue::PopsLowest>;

use List::Priority;

sub new_queue {
	return List::Priority->new();
}

sub insert {
	my ($self, $l, $obj, $priority) = @_;
	$l->insert($priority, $obj);
}

sub pop_highest {
	my ($self, $l) = @_;
	return $l->pop();
}

sub pop_lowest {
	my ($self, $l) = @_;
	return $l->shift();
}

sub module_tested {
	return 'List::Priority';
}

1;
__END__

=head1 NAME

Benchmark::PriorityQueue::List::Priority - benchmark List::Priority.

=head1 SEE ALSO

L<Benchmark::PriorityQueue>, L<List::Priority>.

=head1 AUTHOR

Miles Gould, E<lt>miles@assyrian.org.ukE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Miles Gould

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.12.4 or,
at your option, any later version of Perl 5 you may have available.

=cut

package Benchmark::PriorityQueue::Data::PrioQ::SkewBinomial;

use strict;
use warnings;
use parent 'Benchmark::PriorityQueue::Base';
use Data::PrioQ::SkewBinomial;

sub new_queue {
	return Data::PrioQ::SkewBinomial::empty;
}

sub insert {
	# my ($self, $l, $object, $priority) = @_;
	$_[1] = $_[1]->insert($_[3], $_[2]);
}

sub module_tested {
	return "Data::PrioQ::SkewBinomial";
}

1;
__END__

=head1 NAME

Benchmark::PriorityQueue::Data::PrioQ::SkewBinomial - benchmark
Data::PrioQ::SkewBinomial.

=head1 SEE ALSO

L<Benchmark::PriorityQueue>, L<Data::PrioQ::SkewBinomial>.

=head1 AUTHOR

Miles Gould, E<lt>miles@assyrian.org.ukE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Miles Gould

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.12.4 or,
at your option, any later version of Perl 5 you may have available.

=cut

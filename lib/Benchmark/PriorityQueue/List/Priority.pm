package Benchmark::PriorityQueue::List::Priority;

use strict;
use warnings;
use List::Priority;
use Benchmark qw/:all/;

sub new {
        my $this = shift;
        my $class = ref($this) || $this;
        my $self = {};
        bless $self, $class;
	return $self;
}

sub random_insert {
	my $n = shift;
	my $l = List::Priority->new();
	return timeit(10, sub {
		for my $i (1 .. $n) {
			$l->insert(rand(), $i);
		}
	});
}

sub ordered_insert {
	my $n = shift;
	my $l = List::Priority->new();
	return timeit(10, sub {
		for my $i (1 .. $n) {
			$l->insert($i, $i);
		}
	});
}

sub supported {
	return (
		'random_insert' => \&random_insert,
		'ordered_insert' => \&ordered_insert,
	);
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

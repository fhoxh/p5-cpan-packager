# Copyright © 2009, 2010 Takatoshi Kitano.
#
# This library is free software; you can redistribute it and/or modify it under
# the same terms as Perl 5.10.1. For more details, see the full text of the
# licenses in the directory LICENSES.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.

package CPAN::Packager::ListUtil;
use strict;
require Exporter;
use vars qw($VERSION @ISA @EXPORT_OK %EXPORT_TAGS);
@ISA = qw(Exporter);

%EXPORT_TAGS = ( all => [qw(any all none uniq)], );

@EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

sub any (&@) { ## no critic
    my $f = shift;
    return if !@_;
    for (@_) {
        return 1 if $f->();
    }
    return 0;
}

sub all (&@) { ## no critic
    my $f = shift;
    return if !@_;
    for (@_) {
        return 0 if !$f->();
    }
    return 1;
}

sub none (&@) { ## no critic
    my $f = shift;
    return if !@_;
    for (@_) {
        return 0 if $f->();
    }
    return 1;
}

sub uniq (@) { ## no critic
    my %h;
    map { $h{$_}++ == 0 ? $_ : () } @_;
}

1;
__END__


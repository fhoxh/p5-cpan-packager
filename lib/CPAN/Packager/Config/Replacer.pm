# Copyright © 2009, 2010 Takatoshi Kitano.
#
# This library is free software; you can redistribute it and/or modify it under
# the same terms as Perl 5.10.1. For more details, see the full text of the
# licenses in the directory LICENSES.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.

package CPAN::Packager::Config::Replacer;
use strict;
use warnings;

sub replace_variable {
    my ($class, $variable) = @_;
    $variable = $class->_replace_home($variable);
    $variable;
}

sub _replace_home {
    my ($class, $variable) = @_;
    $variable =~ s/^~/$ENV{HOME}/; 
    $variable;
}

1;

__END__

=head1 NAME

CPAN::Packager::Config::Replacer - replace variables like HOME

=head1 SYNOPSIS

  use CPAN::Packager::Config::Replacer;

=head1 DESCRIPTION


=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

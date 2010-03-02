# Copyright © 2009, 2010 Takatoshi Kitano.
#
# This library is free software; you can redistribute it and/or modify it under
# the same terms as Perl 5.10.1. For more details, see the full text of the
# licenses in the directory LICENSES.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.

package CPAN::Packager::DependencyFilter::Deb;
use Mouse;
with 'CPAN::Packager::DependencyFilter::Role';

__PACKAGE__->meta->make_immutable;
1;

__END__

=head1 NAME

CPAN::Packager::DependencyFilter::Deb - filter module dependencies

=head1 SYNOPSIS

  use CPAN::Packager::DependencyFilter::Deb;

=head1 DESCRIPTION


=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

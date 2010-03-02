# Copyright © 2009, 2010 Takatoshi Kitano.
#
# This library is free software; you can redistribute it and/or modify it under
# the same terms as Perl 5.10.1. For more details, see the full text of the
# licenses in the directory LICENSES.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.

package CPAN::Packager::Config::Validator;
use strict;
use warnings;
use CPAN::Packager::Config::Schema;
use Kwalify;
use Log::Log4perl qw(:easy);

sub validate {
    my ( $class, $config ) = @_;
    my $schema = CPAN::Packager::Config::Schema->schema();
    $class->_validate_config( $config, $schema );
}

sub _validate_config {
    my ( $class, $config, $schema ) = @_;
    if ($schema) {
        my $res = Kwalify::validate( $schema, $config );
        unless ( $res == 1 ) {
            die "config.yaml validation error : $res";
        }
    }
    else {
        WARN("Kwalify is not installed. Skipping the config validation.");
    }
}

1;

__END__

=head1 NAME

CPAN::Packager::Config::Validator - validates configration

=head1 SYNOPSIS


=head1 DESCRIPTION


=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

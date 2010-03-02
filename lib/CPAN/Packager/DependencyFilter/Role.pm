# Copyright © 2009, 2010 Takatoshi Kitano.
#
# This library is free software; you can redistribute it and/or modify it under
# the same terms as Perl 5.10.1. For more details, see the full text of the
# licenses in the directory LICENSES.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.

package CPAN::Packager::DependencyFilter::Role;
use Mouse::Role;
use List::Compare;

sub filter_dependencies {
    my ( $self, $module, $depends, $dependency_config ) = @_;
    $depends = $self->_filter_module_dependensies( $module, $depends,
        $dependency_config );
    $depends
        = $self->_filter_global_dependencies( $depends, $dependency_config );
    wantarray ? @$depends : $depends;
}

sub _filter_global_dependencies {
    my ( $self, $depends, $conf ) = @_;
    my $no_depends
        = $conf->{global}->{no_depends} ? $conf->{global}->{no_depends} : [];
    $depends = $self->_first_list_uniq( 
        [ map { ref $_ eq "HASH" ? $_->{module} : $_ } @{ $depends || () } ], 
        [ map { $_->{module} } @{ $no_depends || () } ] 
    );
    wantarray ? @$depends : $depends;
}

sub _filter_module_dependensies {
    my ( $self, $module, $depends, $conf ) = @_;
    my $no_depends
        = $conf->{modules}->{$module}
        && $conf->{modules}->{$module}->{no_depends}
        ? $conf->{modules}->{$module}->{no_depends}
        : [];
    $depends = $self->_first_list_uniq( 
        [ map { ref $_ eq "HASH" ? $_->{module} : $_ } @{ $depends || () } ], 
        [ map { $_->{module} } @{ $no_depends } ]
    );
    wantarray ? @$depends : $depends;
}

sub _first_list_uniq {
    my ( $self, $depends, $no_depends ) = @_;
    my @new_depends = List::Compare->new( $depends, $no_depends )->get_unique;
    wantarray ? @new_depends : \@new_depends;
}

1;

__END__

=head1 NAME

CPAN::Packager::DependencyFilter::Role - filter module dependencies

=head1 SYNOPSIS

  use CPAN::Packager::DependencyFilter::Role;

=head1 DESCRIPTION


=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

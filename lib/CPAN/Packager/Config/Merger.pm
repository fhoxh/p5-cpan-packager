# Copyright © 2009, 2010 Takatoshi Kitano.
#
# This library is free software; you can redistribute it and/or modify it under
# the same terms as Perl 5.10.1. For more details, see the full text of the
# licenses in the directory LICENSES.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.

package CPAN::Packager::Config::Merger;
use Mouse;
use YAML;
use CPAN::Packager::Config::Loader;
use List::Compare;
use CPAN::Packager::ListUtil qw(any);
use Hash::Merge qw(merge);
Hash::Merge::set_behavior('RIGHT_PRECEDENT');

sub merge_module_config {
    my ( $self, $modules, $config ) = @_;
    my $merged_modules = merge( $modules, $config->{modules} );
    $self->_filter_depends($merged_modules, $config);
    $config->{modules} = $merged_modules;
    $config;
}

sub _filter_depends {
    my ($self, $modules, $config) = @_;
   for my $module ( values %{$modules} ) {
        next unless $module->{module} && $module->{depends} && $module->{no_depends};
        next if ( $config->{global}->{no_depends} && any { $_->{module} eq $module } @{ $config->{global}->{no_depends} } );
        # FIXME: hmm.
        my @new_depends = List::Compare->new( 
            [ map { ( ref $_ eq "HASH" ) ? $_->{module} : $_ } @{ $module->{depends} || () } ] , 
            [ map { $_->{module} } @{ $module->{no_depends} || () } ]
        )->get_unique;
        $module->{depends} = \@new_depends;
    }
}

no Mouse;
__PACKAGE__->meta->make_immutable;
1;

__END__

=head1 NAME

CPAN::Packager::Config::Merger - merge dependency config

=head1 SYNOPSIS


=head1 DESCRIPTION


=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

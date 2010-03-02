# Copyright © 2009, 2010 Takatoshi Kitano.
#
# This library is free software; you can redistribute it and/or modify it under
# the same terms as Perl 5.10.1. For more details, see the full text of the
# licenses in the directory LICENSES.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.

package CPAN::Packager::MetaAnalyzer;
use Mouse;
use Parse::CPAN::Meta ();
use Try::Tiny;
use Log::Log4perl qw(:easy);
use CPAN::Packager::FileUtil qw(file dir);
use CPAN::Packager::ListUtil qw(uniq any);

sub get_dependencies_from_meta {
    my ( $self, $dist_dir ) = @_;

    my ($metayml) = grep -e file( $dist_dir, $_ ), qw( MYMETA.yml META.yml );
    if ($metayml) {
        $metayml = file( $dist_dir, $metayml );
        return $self->get_dependencies_from_metayaml_file( $metayml,
            $dist_dir );
    }
    else {
        [];
    }
}

sub get_dependencies_from_metayaml_file {
    my ( $self, $metayml, $dist_dir ) = @_;
    my $meta = {};
    my %deps;
    try {
        $meta = $self->parse_meta($metayml);
        %deps = ( %{ $meta->{requires} || {} } );
        %deps = (
            %deps,
            %{ $meta->{build_requires} || {} },
            %{ $meta->{test_requires}  || {} }
        );
    }
    catch {

        # FIXME: hmm
        if ($dist_dir) {
            DEBUG( "Can't parse META.yml:" . $_ );
            my $dependencies
                = Module::Depends::Intrusive->new->dist_dir($dist_dir)
                ->find_modules;
            %deps = (
                %{ $dependencies->{requires} || {} },
                %{ $dependencies->{build_requires} || {} }
            );
        }
    };
    my @dependencies = uniq( keys %deps );
    return \@dependencies;
}

sub parse_meta {
    my ( $self, $file ) = @_;
    return ( Parse::CPAN::Meta::LoadFile($file) )[0];
}

sub parse_meta_from_content {
    my ($self, $file_content) = @_;
    return ( Parse::CPAN::Meta::Load($file_content) )[0];
}

__PACKAGE__->meta->make_immutable;
1;

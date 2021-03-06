# Copyright © 2009, 2010 Takatoshi Kitano.
#
# This library is free software; you can redistribute it and/or modify it under
# the same terms as Perl 5.10.1. For more details, see the full text of the
# licenses in the directory LICENSES.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.

package CPAN::Packager::Downloader::CPANPLUS;
use Mouse;
use CPANPLUS::Backend;
use CPAN::Packager::FileUtil qw(file dir);
use URI;
use Log::Log4perl qw(:easy);
use Try::Tiny;
with 'CPAN::Packager::Downloader::Role';

has 'fetcher' => (
    is      => 'rw',
    default => sub {
        CPANPLUS::Backend->new;
    }
);

sub set_cpan_mirrors {
    my ( $self, $cpan_mirrors ) = @_;
    my $hosts = [];
    foreach my $mirror (@$cpan_mirrors) {
        my $uri  = URI->new($mirror);
        my $host = {
            path   => $uri->path,
            scheme => $uri->scheme,
            host   => $uri->host,
        };
        push @{$hosts}, $host;
    }
    my $cpanp_conf = $self->fetcher->configure_object;
    $cpanp_conf->set_conf( 'hosts' => $hosts );
}

sub download {
    my ( $self, $module ) = @_;
    INFO( "Downloading $module ..." );
    my $dist = $self->fetcher->parse_module( module => $module );
    return unless $dist;

    my ( $archive, $where );
    my $is_force = $dist->is_uptodate ? 0 : 1;
    try {
        $archive = $dist->fetch( force => $is_force ) or next;
        $where = $dist->extract( force => $is_force ) or next;
    };

    return () unless $archive;
    return $self->analyze_distname_info($archive, $where);
}

no Mouse;
__PACKAGE__->meta->make_immutable;
1;

__END__

=head1 NAME

CPAN::Packager::Downloader::CPANPLUS - Download cpan module tarball from CPAN with CPANPLUS

=head1 SYNOPSIS

  use CPAN::Packager::Downloader::CPANPLUS;
  my $d = CPAN::Packager::Downloader::CPANPLUS->new;
  $d->download('HTTP::Engine');

=head1 DESCRIPTION

CPAN::Packager::Downloader fetches a cpan module tarball from CPAN.

=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

# Copyright © 2009, 2010 Takatoshi Kitano.
#
# This library is free software; you can redistribute it and/or modify it under
# the same terms as Perl 5.10.1. For more details, see the full text of the
# licenses in the directory LICENSES.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.

package CPAN::Packager::ModuleNameResolver;
use Mouse;
use LWP::UserAgent;
use CPAN::Packager::ListUtil qw(any);
use Log::Log4perl qw(:easy);

has 'ua' => (
    is      => 'rw',
    default => sub {
        my $ua = LWP::UserAgent->new;
        $ua->env_proxy;
        $ua;
    }
);

sub resolve {
    my ( $self, $module  ) = @_;
    return $module if any { $module eq $_} ('perl', 'PerlInterp');

    my $res = $self->get_or_retry(
        "http://search.cpan.org/search?query=$module&mode=module");
    return unless $res->is_success;
    my ($resolved_module)
        = $res->content =~ m{<a href="/~[^/]+/([-\w]+?)-\d[.\w]+/">};

    return unless $resolved_module;
    $resolved_module =~ s/-/::/g unless $resolved_module eq 'libwww-perl';
    DEBUG( ">>> resolved module name is ${resolved_module} and original module name is ${module}"
    );
    return $resolved_module;
}

sub get_or_retry {
    my ( $self, $url ) = @_;
    my $res = $self->ua->get($url);
    $res->is_success ? $res : $self->ua->get($url);
}

__PACKAGE__->meta->make_immutable;
1;

__END__

=head1 NAME

CPAN::Packager::ModuleNameResolver - resolve CPAN module name from CPAN

=head1 SYNOPSIS

    use CPAN::Packager::ModuleNameResolver;
    my $config = ...
    my $resolver = CPAN::Packager::ModuleNameResolver->new;
    $resolved_module = $resolver->resolve_module_name( 'Mouse', $config );

=head1 DESCRIPTION


=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

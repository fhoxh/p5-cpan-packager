package CPAN::Packager::Builder::Deb;
use Mouse;
use Carp;
use IPC::System::Simple qw(system);
use Path::Class;
use LWP::UserAgent;
with 'CPAN::Packager::Builder::Role';
with 'CPAN::Packager::Role::Logger';

has 'package_output_dir' => (
    is      => 'rw',
    default => sub {
        my $self = shift;
        dir( '/', 'tmp', 'cpanpackager', 'deb' );
    },
);

has 'resolved' => (
    is      => 'rw',
    default => sub {
        +{};
    }
);

sub BUILD {
    my $self = shift;
    system("which dh-make-perl > /dev/null")
        and croak "dh-make-perl is not found in PATH";
    $self->package_output_dir->mkpath;
    $self;
}

sub build {
    my ( $self, $info ) = @_;
    $self->_build_package_with_dh_make_perl($info);
}

sub _build_package_with_dh_make_perl {
    my ( $self, $info ) = @_;
    my $module  = $self->resolve_module_name( $info->{module} );
    my $pkg     = $self->package_name($module);
    my @depends = qw(perl);

    my $depends = join ',', @depends;
    my $package_output_dir = $self->package_output_dir;

    eval {
        system("sudo rm -rf $info->{src}/debian");
        system(
            "sudo dh-make-perl --build --notest --depends '$depends' $info->{src}"
        );
        system("sudo mv $info->{src}/../$pkg*.deb $package_output_dir");
    };
    if ($@) {
        $self->log( info => $@ );
    }
    $pkg;
}

sub package_name {
    my ($self,$module) = @_;
    return $module if $module eq 'libwww-perl';
    $module =~ s{::}{-}g;
    $module =~ s{_}{-}g;
    'lib' . lc($module) . '-perl';
}

sub installed_packages {
    my @installed_pkg;
    my $is_pkg = 0;
    for my $l ( split /[¥r¥n]+/, qx{LANG=C dpkg -l 'lib*-perl'} ) {
        if ( $l =~ /^[+]{3}/ ) {
            $is_pkg = 1;
        }
        elsif ( $is_pkg && $l =~ /^ii/ ) {    # if installed
            my ( $stat, $pkg, $ver, $desc ) = split ' ', $l;
            push @installed_pkg, $pkg;
        }
    }
    @installed_pkg;
}

sub print_installed_packages {
    my ($self) = @_;
    my $installed_file = file( $self->package_output_dir, 'installed' );
    my $fh = $installed_file->openw;
    print $fh "aptitude -y install $_¥n" for $self->installed_packages;
    close $fh;
}

no Mouse;
__PACKAGE__->meta->make_immutable;
1;

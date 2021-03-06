sub readme_from {
    warn
        "You need to install Module::Install::ReadmeFromPod to generate README";
}

sub use_test_base {
    warn "You need to install Test::Base to run make test from git clone";
}

sub author_requires {
    warn
        "You need to install Module::Install::AuthorRequires to install modules author requires";
}
sub author_tests        { }
sub auto_set_repository { }

use inc::Module::Install;

{
    no warnings 'redefine';
    *recommends_hack
        = $Module::Install::VERSION > 0.70
        ? sub { recommends(@_); $_[0] }
        : \&recommends;
}

name 'CPAN-Packager';
all_from 'lib/CPAN/Packager.pm';
readme_from 'lib/CPAN/Packager/Manual.pod';

requires(
    'File::Copy'                => 0,
    'FindBin::libs'             => 0,
    'Hash::Merge'               => 0,
    'LWP::UserAgent'            => 0,
    'List::Compare'             => 0,
    'Module::CoreList'          => '2.17',
    'Module::Depends'           => 0,
    'Mouse'                     => '0.47',
    'MouseX::Getopt'            => '0.2601',
    'Getopt::Long::Descriptive' => '0.083',
    'Archive::Extract'          => 0,
    'YAML'                      => 0,
    'Kwalify'                   => '1.20',
    'CPAN::DistnameInfo'        => 0,
    'Log::Log4perl'             => '1.26',
    'Try::Tiny'                 => '0.04',
    'IPC::Cmd'                  => 0,
    'IO::File'                  => 0,
    'Parse::CPAN::Meta'         => 0,
);

features(
    'build RPM package?' => [
        -default => 0,
        recommends_hack( 'RPM::Specfile'  => 0 ),
        recommends_hack( 'Archive::Tar'   => 0 ),
        recommends_hack( 'Archive::Zip'   => 0 ),
        recommends_hack( 'File::Temp'     => 0 ),
        recommends_hack( 'URI::Escape'    => 0 ),
        recommends_hack( 'Cwd'            => 0 ),
        recommends_hack( 'File::Basename' => 0 ),
    ],
    'use App::CPAN::Fresh as a module downloader?' => [
        -default => 0,
        recommends_hack( 'App::CPAN::Fresh' => 0 ),
        recommends_hack( 'URI'              => 0 ),
    ],
    'use CPANPLUS as a module downloader?' => [
        -default => 0,
        recommends_hack( 'CPANPLUS::Backend' => 0 ),
        recommends_hack( 'URI'               => 0 ),
    ],
);

test_requires(
    'Test::More'           => '0.94',
    'Test::Base'           => 0,
    'Test::LoadAllModules' => '0.02',
    'Test::Requires'       => '0.03',
);

# Module::Install::AuthorRequires
author_requires(
    'Module::Install::Repository'  => 0,
    'Module::Install::AuthorTests' => 0,
    'Test::Pod'                    => 0,
    'Test::NoTabs'                 => 0,
    'Test::Perl::Critic'           => 0,
);

tests( 't/*.t t/0*/*.t', );

author_tests('xt');

install_script('bin/cpan-packager');
use_test_base;
auto_include;
auto_set_repository;
WriteAll;

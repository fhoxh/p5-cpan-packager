# Copyright © 2009, 2010 Takatoshi Kitano.
#
# This library is free software; you can redistribute it and/or modify it under
# the same terms as Perl 5.10.1. For more details, see the full text of the
# licenses in the directory LICENSES.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.

package CPAN::Packager::DualLivedList;
use Mouse;

# FIXME
# copied from Bundle::duallived
# we need to implement Module::DualLivedList
my $DUAL_LIVED_LIST = {
    "autodie"                   => 1,
    "base"                      => 1,
    "bigint"                    => 1,
    "constant"                  => 1,
    "encoding"                  => 1,
    "encoding::warnings"        => 1,
    "if"                        => 1,
    "lib"                       => 1,
    "parent"                    => 1,
    "threads"                   => 1,
    "threads::shared"           => 1,
    "version"                   => 1,
    "Test::Harness"             => 1,
    "Archive::Extract"          => 1,
    "Archive::Tar"              => 1,
    "Attribute::Handlers"       => 1,
    "AutoLoader"                => 1,
    "B::Debug"                  => 1,
    "B::Lint"                   => 1,
    "CGI"                       => 1,
    "CPAN"                      => 1,
    "CPANPLUS"                  => 1,
    "CPANPLUS::Dist::Build"     => 1,
    "Class::ISA"                => 1,
    "Compress::Raw::Bzip2"      => 1,
    "Compress::Raw::Zlib"       => 1,
    "Compress::Zlib"            => 1,
    "Cwd"                       => 1,
    "DB_File"                   => 1,
    "Data::Dumper"              => 1,
    "Devel::InnerPackage"       => 1,
    "Devel::PPPort"             => 1,
    "Digest"                    => 1,
    "Digest::MD5"               => 1,
    "Digest::SHA"               => 1,
    "Exporter"                  => 1,
    "ExtUtils::CBuilder"        => 1,
    "ExtUtils::Command"         => 1,
    "ExtUtils::MakeMaker"       => 1,
    "ExtUtils::Constant::Base"  => 1,
    "ExtUtils::Install"         => 1,
    "ExtUtils::Manifest"        => 1,
    "ExtUtils::ParseXS"         => 1,
    "File::Fetch"               => 1,
    "File::Path"                => 1,
    "File::Temp"                => 1,
    "Text::Balanced"            => 1,
    "Filter::Simple"            => 1,
    "Filter::Util::Call"        => 1,
    "Getopt::Long"              => 1,
    "I18N::LangTags"            => 1,
    "IO"                        => 1,
    "IO::Compress::Base"        => 1,
    "IO::Zlib"                  => 1,
    "IPC::Cmd"                  => 1,
    "IPC::Msg"                  => 1,
    "List::Util"                => 1,
    "Locale::Constants"         => 1,
    "Locale::Maketext"          => 1,
    "Locale::Maketext::Simple"  => 1,
    "Log::Message"              => 1,
    "MIME::Base64"              => 1,
    "Math::BigInt"              => 1,
    "Math::BigInt::FastCalc"    => 1,
    "Math::BigRat"              => 1,
    "Math::Complex"             => 1,
    "Memoize"                   => 1,
    "Module::Build"             => 1,
    "Module::CoreList"          => 1,
    "Module::Load"              => 1,
    "Module::Load::Conditional" => 1,
    "Module::Loaded"            => 1,
    "Module::Pluggable"         => 1,
    "NEXT"                      => 1,
    "Net::Cmd"                  => 1,
    "Package::Constants"        => 1,
    "Params::Check"             => 1,
    "Parse::CPAN::Meta"         => 1,
    "PerlIO::via::QuotedPrint"  => 1,
    "Pod::Checker"              => 1,
    "Pod::Escapes"              => 1,
    "Pod::LaTeX"                => 1,
    "Pod::Man"                  => 1,
    "Pod::Perldoc"              => 1,
    "Pod::Plainer"              => 1,
    "Pod::Simple"               => 1,
    "Pod::Usage"                => 1,
    "Safe"                      => 1,
    "SelfLoader"                => 1,
    "Shell"                     => 1,
    "Storable"                  => 1,
    "Switch"                    => 1,
    "Sys::Syslog"               => 1,
    "Term::ANSIColor"           => 1,
    "Term::Cap"                 => 1,
    "Term::UI"                  => 1,
    "Test"                      => 1,
    "Test::Simple"              => 1,
    "Text::Balanced"            => 1,
    "Text::ParseWords"          => 1,
    "Text::Soundex"             => 1,
    "Text::Tabs"                => 1,
    "Thread::Queue"             => 1,
    "Thread::Semaphore"         => 1,
    "Tie::File"                 => 1,
    "Tie::RefHash"              => 1,
    "Time::HiRes"               => 1,
    "Time::Local"               => 1,
    "Time::Piece"               => 1,
    "Unicode::Collate"          => 1,
    "Unicode::Normalize"        => 1,
    "Win32"                     => 1,
    "Win32API::File"            => 1,
    "XSLoader"                  => 1,
};

sub is_duallived_module {
    my ( $self, $module_name ) = @_;
    return exists $DUAL_LIVED_LIST->{$module_name};
}

1;

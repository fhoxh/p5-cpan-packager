# Copyright © 2009, 2010 Takatoshi Kitano.
#
# This library is free software; you can redistribute it and/or modify it under
# the same terms as Perl 5.10.1. For more details, see the full text of the
# licenses in the directory LICENSES.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.

package CPAN::Packager::Config::Schema;
use strict;
use warnings;
use YAML ();

sub schema {
    my @lines;
    while (<DATA>) {
        push @lines, $_;
    }
    return YAML::Load( join '', @lines );
}

1;

__DATA__
type: map
mapping:
  global:
    type: map
    mapping:
      "cpan_mirrors":
        type: seq
        sequence:
          - type: str
      "fix_package_depends":
        type: seq
        sequence:
          - type: map
            mapping:
              from:
                type: str
                required: true 
              to:
                type: str
                required: true 
      "no_depends":
        type: seq
        sequence:
          - type: map
            mapping:
              "module":
                type: str
                unique: yes
                required: true
      "skip_name_resolve_modules":
        type: seq
        sequence:
          - type: map
            mapping:
              "module":
                type: str
                unique: yes
                required: true
      "fix_module_name":
        type: seq
        sequence:
          - type: map
            mapping:
              from:
                type: str
                required: true 
              to:
                type: str
                required: true 
  modules:
    type: seq
    sequence:
      - type: map
        mapping:
          "module":
            type: str
            required: true
            unique: yes
          "no_depends":
            type: seq
            sequence:
              - type: map
                mapping:
                  "module":
                    type: str
                    unique: yes
                    required: true
          "depends":
            type: seq
            sequence:
              - type: map
                mapping:
                  "module":
                    type: str
                    unique: yes
                    required: true
          "skip_test":
            type: bool
          "skip_build":
            type: bool
          "force_build":
            type: bool
          "custom":
            type: map
            mapping:
              "tgz_path":
                type: str
              "src_dir":
                type: str
              "version":
                type: any
                required: true
              "dist_name":
                type: str
                required: true
                unique: yes
              "patches":
                type: seq
                sequence:
                  - type: str
          "version":
            type: any
          "release":
            type: int
          "pkg_name":
            type: str
          "epoch":
            type: int
          "obsoletes":
            type: seq
            sequence:
              - type: map
                mapping:
                  "package":
                    type: str
                    unique: yes
                    required: true


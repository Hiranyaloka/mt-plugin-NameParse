# Copyright 2011 Rick Bychowski: Hiranyaloka
# This program is free software; you can redistribute it and/or modify it
# under the terms of either: the GNU General Public License as published
# by the Free Software Foundation; or the Artistic License.
# See http://dev.perl.org/licenses/ for more information.

package NameParse::Plugin;
require Lingua::EN::NameParse;
use strict;
use MT 4;

=head2 Block Tag - `NameParseComponents`

`NameParseComponents`parses the contained block, then joins the components with a separator.
No case conversion. The default separator is whitespace.

=head2 Allowed Arguments:

Separator: e.g. separator = ", "

Components - e.g. given_name_1="1" surname_1 = "1"

precursor, title_1, title_2, given_name_1, given_name_2, initials_1, initials_2
middle_name, conjunction_1, conjunction_2, surname_1. surname_2, suffix

=cut

my $name = new Lingua::EN::NameParse();

sub nameparse_components {
  my ( $ctx, $args, $cond ) = @_;
  my $blog = $ctx->stash('blog') || return;
  defined(my $str = $ctx->slurp($args,$cond)) or return;
  my $error = $name->parse($str);
  my @components = '';
  my %name = $name->components;
  my $separator = $args->{separator} ?  $args->{separator} : " ";
  my @opts = ();
    for my $arg (keys %$args)
      {
        push (@components, $name{$arg}) if  $name{$arg};
      }
  my $out = join "$separator", @components;
  return $out;
}

=head2 Text Filter - case_all_reversed

The case_all_reversed method applies the same type of casing as case_all. However, the name is returned as surname followed by a comma and the rest of the name, which can be any of the combinations allowed for a name, except the title. Some examples are: "Smith, John", "De Silva, A.B." This is useful for sorting names alphabetically by surname.

The method returns the entire reverse order cased name as text.
=cut

sub case_all_reversed {
  my ($str) = @_;
  my $error = $name->parse($str);
  $str = $name->case_all_reversed;
  return $str;
}

1;

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
Optional case conversion with `case` argument. The default separator is whitespace.

=head2 Allowed Arguments:

Separator: e.g. separator = ", "

Components (comma separated values) - e.g. components = "given_name_1,surname_1"

precursor, title_1, title_2, given_name_1, given_name_2, initials_1, initials_2
middle_name, conjunction_1, conjunction_2, surname_1. surname_2, suffix

=cut
my %np_args = (
  autoclean => 1,
  allow_reversed => 1
);
my $name = new Lingua::EN::NameParse(%np_args);
    
sub nameparse_components {
  my ( $ctx, $args, $cond ) = @_;
  my $blog = $ctx->stash('blog') || return;
  my @allowed_components = qw(precursor title_1 title_2 given_name_1 given_name_2
    initials_1 initials_2 middle_name conjunction_1 conjunction_2
    surname_1 surname_2 suffix);
  defined(my $str = $ctx->slurp($args,$cond)) or return;
  my @component_args = split /\s*,\s*/, $args->{components};
  my $error = $name->parse($str);
  my @component_vals;
  my $filtered_comp = intersection(\@component_args,\@allowed_components) or die "no components";
  my  %name = $args->{case} ? $name->case_components : $name->components;
  my $separator = $args->{separator} ?  $args->{separator} : " ";
  for my $comp (@$filtered_comp)
    {
      push (@component_vals, $name{$comp}) if  $name{$comp};
    }
  my $out = join "$separator", @component_vals;
  return $out;
}

=head2 Text Filter - case_all_reversed

The case_all_reversed method uppercases the first letter of each component, and lowercases the rest, with some exceptions.
However, the name is returned as surname followed by a comma and the rest of the name,
which can be any of the combinations allowed for a name, except the title.
Some examples are: "Smith, John", "De Silva, A.B." This is useful for sorting names alphabetically by surname.

The method returns the entire reverse order cased name as text.
=cut

sub case_all_reversed {
  my ($str) = @_;
  my $error = $name->parse($str);
  $str = $name->case_all_reversed;
  return $str;
}

# return elements of first hash that are also in second
sub intersection {
  my ($first, $second) = @_;
  my %second_hash = map {$_=>1} @$second;
  my @intersection = grep {$second_hash{$_} } @$first;
  return \@intersection;
}

1;

package List::Gather;
BEGIN {
  $List::Gather::AUTHORITY = 'cpan:FLORA';
}
{
  $List::Gather::VERSION = '0.02';
}
# ABSTRACT: Construct lists procedurally without temporary variables

use strict;
use warnings;
use Devel::CallParser;
use Devel::CallChecker;

use XSLoader;

XSLoader::load(
    __PACKAGE__,
    $List::Gather::{VERSION} ? ${ $List::Gather::{VERSION} } : (),
);

require B::Hooks::EndOfScope
    unless _QPARSE_DIRECTLY();

my @keywords;
BEGIN { @keywords = qw(gather take gathered) }

use Sub::Exporter -setup => {
    exports => [@keywords],
    groups  => { default => [@keywords] },
};


1;

__END__
=pod

=encoding utf-8

=head1 NAME

List::Gather - Construct lists procedurally without temporary variables

=head1 SYNOPSIS

  use List::Gather;

  my @list = gather {
      # Try to extract odd numbers and odd number names...
      for (@data) {
          if (/(one|three|five|seven|nine)$/) {
              take qq{'$_'};
          }
          elsif (/^\d+$/ && $_ %2) {
              take $_;
          }
      }

      # But use the default set if there aren't any of either...
      take @defaults unless gathered;
  }

=head1 DESCRIPTION

This module provides a C<gather> keyword that allows lists to be constructed
procedurally, without the need for a temporary variable.

Within the block controlled by a C<gather> any call to C<take> pushes that
call's argument list to an implicitly created array.

C<gather> returns the list of values taken during its block's execution.

=head1 FUNCTIONS

=head2 gather

  gather { ... };
  gather({ ... });

Executes the block it has been provided with, collecting all arguments passed to
C<take> calls within it. After execution, the list of values collected is
returned.

Parens around the C<gather> block are optional.

=head2 take

  take LIST;

Collects a C<LIST> of values within the currently executing C<gather> block.

C<take> returns no meaningful value.

C<take> calls outside of the lexical scope of a C<gather> block are compile time
errors. Calling C<take> is only legal within the dynamic scope its associated
C<gather> block.

=head2 gathered

  gathered;

Returns the list of items collected so far during the execution of a C<gather>
block.

C<gathered> calls outside of the lexical scope of a C<gather> block are compile
time errors. Calling C<gathered> outside of the dynamic scope of its associated
C<gather> block is legal.

=head1 SEE ALSO

=over 4

=item L<Syntax::Keyword::Gather>

A non-lexical gather/take implementation that's otherwise very similar to this one

=item L<Perl6::GatherTake>

An experimental implementation of a lazily evaluating gather/take

=item L<Perl6::Take>

A very simple gather/take implementation without lexical scoping

=item L<Perl6::Gather>

Like L<Syntax::Keyword::Gather>, but reliant on L<Perl6::Export>

=item L<List::Gen>

A comprehensive suit list generation functions featuring a non-lexical gather/take

=back

=head1 ACKNOWLEDGEMENTS

=over 4

=item *

Andrew Main (Zefram) E<lt>zefram@fysh.orgE<gt>

for providing his input in both the design and implementation of this module,
and writing much of the infrastructure that made this module possible in the
first place

=item *

Arthur Axel "fREW" Schmidt E<lt>frioux+cpan@gmail.comE<gt>

for his input on various aspects of this module as well as the many tests of his
L<Syntax::Keyword::Gather> module that this module shamelessly stole

=back

=head1 AUTHOR

Florian Ragwitz <rafl@debian.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Florian Ragwitz.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


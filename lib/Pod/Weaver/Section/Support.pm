# 
# This file is part of Pod-Weaver-Section-Support
# 
# This software is copyright (c) 2010 by Apocalypse.
# 
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
# 
use strict; use warnings;
package Pod::Weaver::Section::Support;
BEGIN {
  $Pod::Weaver::Section::Support::VERSION = '0.006';
}
BEGIN {
  $Pod::Weaver::Section::Support::AUTHORITY = 'cpan:APOCAL';
}

# ABSTRACT: add a SUPPORT pod section

use Moose 1.01;
use Moose::Autobox 0.10;

use Pod::Weaver::Role::Section 3.100710;
with 'Pod::Weaver::Role::Section';

sub weave_section {
	my ($self, $document, $input) = @_;

	my $zilla = $input->{zilla} or return;

	# Is this the main module POD?
	my $main = $zilla->main_module->name;
	return if $main ne $input->{filename};

	my $dist = $zilla->name;
	my $first_char = substr( $dist, 0, 1 );
	my $lc_dist = lc( $dist );
	my $perl_name = $dist;
	$perl_name =~ s/-/::/g;
	my $repository = $zilla->distmeta->{resources}{repository} or die 'repository not present in distmeta';

	$document->children->push(
		# Add the stopwords so the spell checker won't complain!
		Pod::Elemental::Element::Pod5::Region->new( {
			format_name => 'stopwords',
			content => '',
			children => [
				Pod::Elemental::Element::Pod5::Ordinary->new( {
					content => 'CPAN AnnoCPAN RT CPANTS Kwalitee',
				} ),
			],
		} ),
		Pod::Elemental::Element::Nested->new( {
			command => 'head1',
			content => 'SUPPORT',
			children => [
				Pod::Elemental::Element::Pod5::Ordinary->new( {
					content => <<EOPOD,
You can find documentation for this module with the perldoc command.
EOPOD
				} ),
				Pod::Elemental::Element::Pod5::Verbatim->new( {
					content => "  perldoc $perl_name",
				} ),
				Pod::Elemental::Element::Nested->new( {
					command => 'head2',
					content => 'Websites',
					children => [
						Pod::Elemental::Element::Nested->new( {
							command => 'over',
							content => '4',
							children => [
								_make_item( 'Search CPAN', "L<http://search.cpan.org/dist/$dist>" ),
								_make_item( 'AnnoCPAN: Annotated CPAN documentation', "L<http://annocpan.org/dist/$dist>" ),
								_make_item( 'CPAN Ratings', "L<http://cpanratings.perl.org/d/$dist>" ),
								_make_item( 'CPAN Forum', "L<http://cpanforum.com/dist/$dist>" ),
								_make_item( 'RT: CPAN\'s Bug Tracker', "L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=$dist>" ),
								_make_item( 'CPANTS Kwalitee', "L<http://cpants.perl.org/dist/overview/$dist>" ),
								_make_item( 'CPAN Testers Results', "L<http://cpantesters.org/distro/$first_char/$dist.html>" ),
								_make_item( 'CPAN Testers Matrix', "L<http://matrix.cpantesters.org/?dist=$dist>" ),
								_make_item( 'Source Code Repository', <<EOPOD
The code is open to the world, and available for you to hack on. Please feel free to browse it and play
with it, or whatever. If you want to contribute patches, please send me a diff or prod me to pull
from your repository :)

L<$repository>
EOPOD
								),
								Pod::Elemental::Element::Pod5::Command->new( {
									command => 'back',
									content => '',
								} ),
							],
						} ),
					],
				} ),
				Pod::Elemental::Element::Nested->new( {
					command => 'head2',
					content => 'Bugs',
					children => [
						Pod::Elemental::Element::Pod5::Ordinary->new( {
							content => <<EOPOD,
Please report any bugs or feature requests to C<bug-$lc_dist at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=$dist>.  I will be
notified, and then you'll automatically be notified of progress on your bug as I make changes.
EOPOD
						} ),
					],
				} ),
			],
		} ),
	);
}

sub _make_item {
	my( $title, $contents ) = @_;

	my $str = $title;
	if ( defined $contents ) {
		$str .= "\n\n$contents";
	}

	return Pod::Elemental::Element::Nested->new( {
		command => 'item',
		content => '*',
		children => [
			Pod::Elemental::Element::Pod5::Ordinary->new( {
				content => $str,
			} ),
		],
	} );
}

1;


__END__
=pod

=head1 NAME

Pod::Weaver::Section::Support - add a SUPPORT pod section

=head1 VERSION

  This document describes v0.006 of Pod::Weaver::Section::Support - released May 11, 2010 as part of Pod-Weaver-Section-Support.

=head1 DESCRIPTION

This section plugin will produce a hunk of pod that lists the common support websites
and an explanation of how to report bugs. It will do this only if it is being built with L<Dist::Zilla>
because it needs the data from the dzil object.

This is added B<ONLY> to the main module's POD, because it would be a waste of space to add it to all
modules in the dist.

For an example of what the hunk looks like, look at the L</SUPPORT> section in this POD :)

=for :stopwords CPAN AnnoCPAN RT CPANTS Kwalitee

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

  perldoc Pod::Weaver::Section::Support

=head2 Websites

=over 4

=item *

Search CPAN

L<http://search.cpan.org/dist/Pod-Weaver-Section-Support>

=item *

AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Pod-Weaver-Section-Support>

=item *

CPAN Ratings

L<http://cpanratings.perl.org/d/Pod-Weaver-Section-Support>

=item *

CPAN Forum

L<http://cpanforum.com/dist/Pod-Weaver-Section-Support>

=item *

RT: CPAN's Bug Tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Pod-Weaver-Section-Support>

=item *

CPANTS Kwalitee

L<http://cpants.perl.org/dist/overview/Pod-Weaver-Section-Support>

=item *

CPAN Testers Results

L<http://cpantesters.org/distro/P/Pod-Weaver-Section-Support.html>

=item *

CPAN Testers Matrix

L<http://matrix.cpantesters.org/?dist=Pod-Weaver-Section-Support>

=item *

Source Code Repository

The code is open to the world, and available for you to hack on. Please feel free to browse it and play
with it, or whatever. If you want to contribute patches, please send me a diff or prod me to pull
from your repository :)

L<http://github.com/apocalypse/perl-pod-weaver-section-support>

=back

=head2 Bugs

Please report any bugs or feature requests to C<bug-pod-weaver-section-support at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Pod-Weaver-Section-Support>.  I will be
notified, and then you'll automatically be notified of progress on your bug as I make changes.

=head1 AUTHOR

  Apocalypse <APOCAL@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Apocalypse.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

The full text of the license can be found in the F<LICENSE> file included with this distribution.

=cut


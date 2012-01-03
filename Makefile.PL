
use strict;
use warnings;

use 5.006;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Add a SUPPORT section to your POD",
  "AUTHOR" => "Apocalypse <APOCAL\@cpan.org>",
  "BUILD_REQUIRES" => {
    "File::Find" => 0,
    "File::Temp" => 0,
    "Module::Build" => "0.3601",
    "Test::More" => "0.88"
  },
  "CONFIGURE_REQUIRES" => {
    "Module::Build" => "0.3601"
  },
  "DISTNAME" => "Pod-Weaver-Section-Support",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "Pod::Weaver::Section::Support",
  "PREREQ_PM" => {
    "Moose" => "1.03",
    "Moose::Autobox" => "0.10",
    "Moose::Util::TypeConstraints" => "1.01",
    "Pod::Weaver::Role::Section" => "3.100710",
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "1.005",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);




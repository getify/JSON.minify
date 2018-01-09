#!/usr/bin/perl

use 5.008;
use strict;
use warnings;

no warnings 'syntax';

use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

my $PACKAGE    =  'JSON_minify';
my $LIB_FILE   =  'lib/JSON_minify.pm';
   $LIB_FILE   =~ s!::!/!g;
my $LOCAL_ADDR =  'remi';
my $DOMAIN     =  'cohenscali.net';
my $REPO       =  $PACKAGE;
my $REPO_HOST  =  'github.com';
my $ME1        =  'getify';
my $ME2        =  'rcoscali';
my $MAIN_REPO  =  "git://$REPO_HOST/$ME1/$REPO.git";
my $SCND_REPO  =  "git://$REPO_HOST/$ME1/$REPO.git";
my $BRANCH     =  'perl';
my %args = (
    NAME                 =>  $PACKAGE,
    VERSION_FROM         =>  $LIB_FILE,
    ABSTRACT_FROM        =>  $LIB_FILE,
    PREREQ_PM            => {
        'strict'             =>  0,
        'warnings'           =>  0,
    },
    MIN_PERL_VERSION     =>   5.008,
    AUTHOR               =>  "$ME1 <$LOCAL_ADDR\@$DOMAIN>",
    LICENSE              =>  'mit',
    META_MERGE           => {
        test_requires    => {
            'strict'             => 0,
            'warnings'           => 0,
            'Test::More'         => 0,
            'Test::NoWarnings'   => 0,
        },
        resources        => {
            repository   => $MAIN_REPO,
        },
        keywords         => [qw [ JSON, minifier, comments, C/C++ ]],
    },
    EXE_FILES            => [qw [ bin/json_minify.pl ]],
    INSTALLBIN           => "/usr/bin/install"
);

$args {META_MERGE} {build_requires} ||= {
    'ExtUtils::MakeMaker' =>  0,
    %{$args {META_MERGE} {test_requires}}
};

$args {META_MERGE} {configure_requires} ||=
       $args {META_MERGE} {build_requires};


my %filter = (
    MIN_PERL_VERSION     => '6.48',
    LICENSE              => '6.48',
    META_MERGE           => '6.46',
    AUTHOR               => '6.07',
    ABSTRACT_FROM        => '6.07',
);

delete $args {$_} for grep {defined $filter {$_} &&
                            $ExtUtils::MakeMaker::VERSION lt $filter {$_}}
                            keys %args;


WriteMakefile %args;

__END__

#!/usr/bin/perl

use Test::More;
use Test::Pod::Coverage;

use strict;
use warnings;
no  warnings 'syntax';

eval "use Test::Pod::Coverage 1.00";
plan skip_all => "Test::Pod::Coverage required for testing POD" if $@;

all_pod_coverage_ok ({private => [qr /^/]});

done_testing();

__END__

#!/usr/bin/perl

use strict;
use warnings;

use Cwd 'abs_path';
use Test::Most;

chdir 't/etc/' or die $!;

$ENV{'HOME'} = abs_path ('.vcsh_home');
$ENV{'XDG_CONFIG_HOME'} = $ENV{'HOME'}.'/.config';

system ("echo 'Yes, do as I say' | ./vcsh delete test1");

my $output = `./vcsh status`;

ok $output eq "", 'No repos set up anymore.';

done_testing;

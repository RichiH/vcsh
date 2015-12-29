#!/usr/bin/perl

use strict;
use warnings;

use Cwd 'abs_path';

use Shell::Command;
use Test::Most;

chdir 't/etc/' or die $!;

$ENV{'HOME'} = abs_path ('.vcsh_home');

chdir '.vcsh_home' or die $!;

eval {
	touch 'a';
};

die $@ if $@;

system (".././vcsh test1 add 'a'");

my $output = `.././vcsh status`;

ok $output eq "test1:
A  a

", 'Adding a file works';

$output = `.././vcsh status --terse`;

ok $output eq "test1:
A  a
", 'Terse output works';

done_testing;


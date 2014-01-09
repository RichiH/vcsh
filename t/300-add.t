#!/usr/bin/perl

use strict;
use warnings;

use Cwd 'abs_path';

use Shell::Command;
use Test::Most;

chdir 't/etc/' or die $!;

$ENV{'HOME'} = abs_path ('.vcsh_home');

eval {
	touch 'a';
};

die $@ if $@;

system ("./vcsh -d test1 add 'a'");

my $output = `./vcsh status`;

diag $output;

ok $output eq "test1:
A a
", 'Adding a file worksl';

done_testing;


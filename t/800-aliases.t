#!/usr/bin/perl
#
BEGIN { $ENV{LC_ALL} = 'C' }

use strict;
use warnings;

use Cwd 'abs_path';
use Test::Most;

chdir 't/etc/' or die $!;

$ENV{'HOME'} = abs_path ('.vcsh_home');

chdir '.vcsh_home' or die $!;

my $output = `../vcsh alias`;
ok $output eq "", 'No aliases set up yet.';

system("../vcsh alias ls=list");
$output = `../vcsh alias`;
ok $output eq "ls = list\n", 'Add alias ls';

system("../vcsh alias ci=commit -a");
$output = `../vcsh alias`;
ok $output eq "ls = list
ci = commit -a
", 'Add alias ci';

system("../vcsh alias co=upgrade");
$output = `../vcsh alias`;
ok $output eq "ls = list
ci = commit -a
co = upgrade
", 'Add alias co';

$output = `../vcsh alias ci`;
ok $output eq "commit -a\n", 'Get alias ci';

system("../vcsh alias -d ci");
$output = `../vcsh alias`;
ok $output eq "ls = list
co = upgrade
", 'Delete alias ci';

done_testing;


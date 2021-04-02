#!/usr/bin/perl

use strict;
use warnings;

use Cwd 'abs_path';
use Test::Most;

system ("mkdir -p t/etc");
ok !$?;

system ("mkdir -p t/etc/.vcsh_home");
ok !$?;

chdir 't/etc/' or die $!;

system ("ln -s '../../vcsh'");
ok !$?;

$ENV{'HOME'} = abs_path ('.vcsh_home');
$ENV{'XDG_CONFIG_HOME'} = $ENV{'HOME'}.'/.config';

system ("git config --global init.defaultBranch test");
ok !$?;

done_testing;

#!/usr/bin/perl

use strict;
use warnings;

use Test::Most;

system ("mkdir -p t/etc");
ok !$?;

system ("mkdir -p t/etc/.vcsh_home");
ok !$?;

chdir 't/etc/' or die $!;

system ("ln -s '../../vcsh'");
ok !$?;

done_testing;

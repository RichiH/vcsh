#!/usr/bin/perl

BEGIN { $ENV{LC_ALL} = 'C' }

use strict;
use warnings;

use Cwd 'abs_path';
use Test::Most;

chdir 't/etc/' or die $!;

$ENV{'HOME'} = abs_path ('.vcsh_home');

my $output = `./vcsh status`;

ok $output eq "", 'No repos set up yet.';

$output = `./vcsh init test1`;

ok $output eq "Initialized empty Git repository in " . $ENV{'HOME'} . "/.config/vcsh/repo.d/test1.git/\n";

$output = `./vcsh status`;

ok $output eq "test1:\n\n", 'Our new repo is there';

chdir $ENV{"HOME"} . '/.config/vcsh/repo.d/test1.git/' or die $!;

ok -f 'HEAD';
ok -f 'config';
ok -f 'description';
ok -d 'hooks';
ok -d 'info';
ok -d 'objects';
ok -d 'refs';

ok -f 'hooks/applypatch-msg.sample';
ok -f 'hooks/commit-msg.sample';
ok -f 'hooks/post-update.sample';
ok -f 'hooks/pre-applypatch.sample';
ok -f 'hooks/pre-commit.sample';
ok -f 'hooks/pre-push.sample';
ok -f 'hooks/pre-rebase.sample';
ok -f 'hooks/prepare-commit-msg.sample';
ok -f 'hooks/update.sample';

ok -f 'info/exclude';

ok -d 'objects/info';
ok -d 'objects/pack';

ok -d 'refs/heads';
ok -d 'refs/tags';

done_testing;

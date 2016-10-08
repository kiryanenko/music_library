#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
require "$FindBin::Bin/../lib/Local/MusicLibrary.pm";

my %param = (@ARGV);
@ARGV = ();

while (<>) {
	last if $_ eq "q\n";
	next if /^\s*$/;
	Local::MusicLibrary::addTrack($_);
}

my @musicList = Local::MusicLibrary::getList(\%param);
@musicList = Local::MusicLibrary::sortList($param{'--sort'}, \@musicList);
Local::MusicLibrary::printList(\@musicList);

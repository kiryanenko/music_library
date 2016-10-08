#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
require "$FindBin::Bin/../lib/Local/MusicLibrary.pm";

my @musicList;
while (<>) {
	last if $_ eq "q\n";
	next if /^\s*$/;
	Local::MusicLibrary::addTrack($_);
}

Local::MusicLibrary::printList();

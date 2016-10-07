#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
require "$FindBin::Bin/../lib/Local/MusicLibrary.pm";

my @musicList;
while (<>) {
	next if /^\s*$/;
	Local::MusicLibrary::addTrack($_);	
	
}

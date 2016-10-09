#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
require "$FindBin::Bin/../lib/Local/MusicLibrary.pm";

BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';

my %param = (@ARGV);
@ARGV = ();

while (<>) {
	next if /^\s*$/;
	eval {		
		Local::MusicLibrary::addTrack($_);
	1} or do {
		print "Error: $@";
	};
	
}

my @musicList = Local::MusicLibrary::getList(\%param);
@musicList = Local::MusicLibrary::sortList($param{'--sort'}, \@musicList);
Local::MusicLibrary::printList(\@musicList, $param{'--columns'});

#!/usr/bin/env perl

use strict;
use warnings;

use Getopt::Long;

use FindBin;
use lib "$FindBin::Bin/../lib";
use Local::MusicLibrary;
use Local::PrintMusicList;

BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';

my %selections;

my $sort;
my $columns;
GetOptions(
	\%selections, (map {"$_=s"} keys %Local::MusicLibrary::columns),
	'sort=s' => \$sort,
	'columns=s' => \$columns
);

while (<>) {
last if /^q$/;
	next if /^\s*$/;
	eval {		
		Local::MusicLibrary::addTrack($_);
	1} or do {
		print "Error: $@";
	};
}

my @musicList = Local::MusicLibrary::getList(\%selections);
@musicList = Local::MusicLibrary::sortList($sort, \@musicList);
if (defined $columns) {
	my @columns = split /,/, $columns if defined $columns;
	Local::PrintMusicList::printList(\@musicList, \@columns );
} else {
	Local::PrintMusicList::printList(\@musicList)
}

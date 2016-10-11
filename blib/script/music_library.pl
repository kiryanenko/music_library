#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";
use Local::MusicLibrary;
use Getopt::Long;

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
	\%selections, (map {"$_=s"} @Local::MusicLibrary::columns),
	'sort=s' => \$sort,
	'columns=s' => \$columns
);

while (<>) {
	next if /^\s*$/;
	eval {		
		Local::MusicLibrary::addTrack($_);
	1} or do {
		print "Error: $@";
	};
	
}

my @musicList = Local::MusicLibrary::getList(\%selections);
@musicList = Local::MusicLibrary::sortList($sort, \@musicList);
Local::MusicLibrary::printList(\@musicList, $columns);

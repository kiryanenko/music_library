package Tokenize;


use strict;
use warnings;

sub tokenize {
	my $source = shift;
	my %res;
	
	if ($source =~ m!^\./(.+)/(\d{4}) - (.+)/(.+)\.(.+)$!) {
		$res{'group'} = $1;
		$res{'year'} = $2;
		$res{'album'} = $3;
		$res{'track'} = $4;
		$res{'format'} = $5;
	} else {
		die 'Неправильный ввод';
	}
	
	return %res;
}


1;

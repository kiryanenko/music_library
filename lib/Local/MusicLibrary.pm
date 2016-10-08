package Local::MusicLibrary;

use 5.010;
use strict;
use warnings;

use DDP;

BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';

=encoding utf8

=head1 NAME

Local::MusicLibrary - core music library module

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

my @musicLibrary;

sub addTrack {
	my $source = shift;
	my %res;
	
	if ($source =~ m!^\./(.+)/(\d{4}) - (.+)/(.+)\.(.+)$!) {
		$res{'group'} = $1;
		$res{'year'} = $2;
		$res{'album'} = $3;
		$res{'track'} = $4;
		$res{'format'} = $5;
	} else {
		die "Неправильный ввод '$_'";
	}
	
	push @musicLibrary, {%res};

p @musicLibrary;
}

sub getList {
	my @musicList = @musicLibrary;
	 
	return @musicList;
}

sub printList {
	my %maxLength = (			# Хэш максимальных длинн столбцов
		'group' => 0,
		'year' => 0,
		'album' => 0,
		'track' => 0,
		'format' => 0
	);
	my @musicList = @musicLibrary;
			
	for (@musicList) {		
		while ( my ($key, $value) = each($_) ) {
			$maxLength{$key} = length $value if $maxLength{$key} < length $value;
    	}
	}
	
	my $dividingString = '|';
	while ( my ($key, $value) = each(%maxLength) ) {
		$dividingString .= '+' unless length($dividingString) == 1;
		$dividingString .= '-' x ($value + 2); 
	}
	$dividingString .= "|";

	say '/', '-' x (length($dividingString) - 2), "\\";
	
	my $flag = '';
	for (@musicList) {
		if ($flag) { say $dividingString; }
		else { $flag = 1; }
		say '| ', ' ' x ($maxLength{'group'} - length $$_{'group'}), $$_{'group'},
			' | ', ' ' x ($maxLength{'year'} - length $$_{'year'}), $$_{'year'},
			' | ', ' ' x ($maxLength{'album'} - length $$_{'album'}), $$_{'album'},
			' | ', ' ' x ($maxLength{'track'} - length $$_{'track'}), $$_{'track'},
			' | ', ' ' x ($maxLength{'format'} - length $$_{'format'}), $$_{'format'},
			' |';
	}
	say '\\', '-' x (length($dividingString) - 2), "/";
}

1;

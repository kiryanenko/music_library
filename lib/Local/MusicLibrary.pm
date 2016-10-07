package Local::MusicLibrary;

use strict;
use warnings;

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
use DDP;
p @musicLibrary;
}

sub printList {
	my %maxLength = (			# Хэш максимальных длинн столбцов
		'group' => 0,
		'year' => 0,
		'album' => 0;
		'track' => 0;
		'format' => 0;
	);
	my @musicList = @musicLibrary;
			
	for (@musicList) {		
		while ( my ($key, $value) = each($_) ) {
			$maxLength{$key} = length $value if $maxLength{$key} < length $value;
    	}
	}
	
	for (@musicList) {
		
	}
}

1;

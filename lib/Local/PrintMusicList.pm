package Local::PrintMusicList;

use 5.010;
use strict;
use warnings;
use Local::MusicLibrary;

BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';

# Функция печатает таблицу списка композиций согласно параметрам
sub printList {
	my $musicList = shift;
	my $columns = shift || [keys %Local::MusicLibrary::columns];
	
	if (@$musicList && @$columns) {
		my %maxLength;		# Хэш максимальных длинн столбцов
		for (@$columns) { $maxLength{$_} = 0; }

		for (@$musicList) {
			while ( my ($key, $value) = each(%maxLength) ) {
				$maxLength{$key} = length $_->{$key} if $value < length $_->{$key};
			}
		}
		
		my $dividingString = "\n|".join('+', 
			map { '-' x ($maxLength{$_} + 2) } @$columns)."|\n";

		say '/', '-' x (length($dividingString) - 4), "\\";
	
		say join $dividingString, map {
			my $el = $_;
			sprintf '|'.join('|', map { ' %'.$maxLength{$_}.'s ' } @$columns).'|', 
				map { $el->{$_}	} @$columns;
		} @$musicList;
	
		say '\\', '-' x (length($dividingString) - 4), "/";
	}
}

1;

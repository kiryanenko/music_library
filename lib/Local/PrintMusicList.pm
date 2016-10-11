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
	my $param = shift;
	my @columns;
	if (defined $param) { @columns = @$param }
	else { @columns = (keys %Local::MusicLibrary::columns); } 
	
	if (@$musicList && @columns) {
		my %maxLength;		# Хэш максимальных длинн столбцов
		for (@columns) { $maxLength{$_} = 0; }

		for (@$musicList) {
			while ( my ($key, $value) = each(%maxLength) ) {
				$maxLength{$key} = length $_->{$key} if $value < length $_->{$key};
			}
		}
		
		my $dividingString = '|';
		for (@columns) {
			$dividingString .= '+' unless $dividingString eq '|';
			$dividingString .= '-' x ($maxLength{$_} + 2);
		}
		$dividingString .= '|';

		say '/', '-' x (length($dividingString) - 2), "\\";
	
		my $flag = '';
		for (@$musicList) {
			if ($flag) { say $dividingString; }
			else { $flag = 1; }
			for my $key (@columns) {
				printf '| %'.$maxLength{$key}.'s ', $_->{$key};
			}
			say '|';
		}
		say '\\', '-' x (length($dividingString) - 2), "/";
	}
}

1;

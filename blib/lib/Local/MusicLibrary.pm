package Local::MusicLibrary;

use 5.010;
use strict;
use warnings;

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
	
	if ($source =~ m!^\./(.+)/(\d+) - (.+)/(.+)\.(.+)$!) {
		$res{'band'} = $1;
		$res{'year'} = "$2";
		$res{'album'} = $3;
		$res{'track'} = $4;
		$res{'format'} = $5;
	} else {
		die "Неправильный ввод '$_'";
	}
	
	push @musicLibrary, {%res};
}

sub getList {
	my $param = shift;
	
	my @musicList = grep {
		my $flag = 1;
		while ((my ($key, $value) = each($_)) && $flag) {
			$flag = !defined $$param{"--$key"} || 
				($key eq 'year' ? $value == $$param{"--year"} :
					$value eq $$param{"--$key"});
		}
		$flag;
	} @musicLibrary;
	
	return @musicList;
}

sub sortList {
	my $param = shift;
	my $musicList = shift;
	
	if (defined $param) {
		die 'Неправильный параметр сортировки' if $param !~ /^(band|year|album|track|format)$/;
		@$musicList = sort {
			$param eq 'year' ? $$a{'year'} <=> $$b{'year'} : $$a{$param} cmp $$b{$param};
		} @$musicList;
	}
	return @$musicList;
}

sub printList {
	my $musicList = shift;
	my $param = shift;
	my @columns = ('band', 'year', 'album', 'track', 'format');
	@columns = split /,/, $param if defined $param;
	
	if (@$musicList && @columns) {
		my %maxLength = (			# Хэш максимальных длинн столбцов
			'band' => 0,
			'year' => 0,
			'album' => 0,
			'track' => 0,
			'format' => 0
		);
			
		for (@$musicList) {
			while ( my ($key, $value) = each($_) ) {
				$maxLength{$key} = length $value if $maxLength{$key} < length $value;
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
				print '| ', ' ' x ($maxLength{$key} - length $$_{$key}), $$_{$key}, ' ';
			}
			say '|';
		}
		say '\\', '-' x (length($dividingString) - 2), "/";
	}
}

1;

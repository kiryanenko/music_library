package Local::MusicLibrary;

use 5.010;
use strict;
use warnings;
use Tie::IxHash;

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
tie our %columns, "Tie::IxHash";
%columns = (
	'band' => 'string', 
	'year' => 'numeric', 
	'album' => 'string', 
	'track' => 'string', 
	'format' => 'string'
);

# Функция парсит строку с путем к файлу и добавляет в массив @musicLibrary
sub addTrack {
	my $source = shift;
	my %res;
	
	if ($source =~ m!^\./(.+)/(\d+) - (.+)/(.+)\.(\w+)$!) {
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

# Функция возвращает список всех композиций удовлетворяющих параметрам
sub getList {
	my $params = shift;
	
	my @musicList = grep {
		my $flag = 1;
		while ((my ($key, $value) = each(%$params)) && $flag) {
			my $v = $_->{$key};	
			given ($columns{$key}) {
				when ('string') { $flag = $value eq $v; }
				when ('numeric') { $flag = $value == $v; }
			}
		}
		$flag;
	} @musicLibrary;
	
	return @musicList;
}

# Функция возвращает отсортированный список композиций согласно параметрам
sub sortList {
	my $param = shift;
	my $musicList = shift;
	
	if (defined $param) {
		die 'Неправильный параметр сортировки' if keys %columns ~~ $param;
		@$musicList = sort {
			my $res;
			given ($columns{$param}) {
				when ('string') {  $res = $a->{$param} cmp $b->{$param}; }
				when ('numeric') { $res = $a->{$param} <=> $b->{$param}; }
			}
			$res;
		} @$musicList;
	}
	return @$musicList;
}

1;

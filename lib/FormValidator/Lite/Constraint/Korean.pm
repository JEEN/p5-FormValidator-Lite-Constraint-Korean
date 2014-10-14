package FormValidator::Lite::Constraint::Korean;
use strict;
use warnings;
use FormValidator::Lite::Constraint;

our $VERSION = "0.01";

rule 'HANGUL'  => sub { delsp($_) =~ /^\p{InHangul}+$/ };
rule 'RRN'     => sub { $_ =~ /^(?:[0-9]{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[1,2][0-9]|3[0,1]))-[1-4][0-9]{6}$/ };
rule 'KZIP'    => sub { $_ =~ /^\d{3}\-\d{3}$/         };
rule 'KTEL'    => sub { $_ =~ /^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})-?[0-9]{3,4}-?[0-9]{4}$/ };
rule 'KBIZ_ID' => sub { $_ =~ /^\d{3}\-\d{2}\-\d{5}$/  };
rule 'KBIZ_ID_STRICT' => sub {
    my $val = $_;

    $val =~ s/\-//g;
    my @check_nums = qw(1 3 7 1 3 7 1 3 5);
    my $sum = 0;
    my @splitted_nums = split '', $val;
    for (my $i = 0; $i < scalar @check_nums; $i++) {
    	$sum += $check_nums[$i] * $splitted_nums[$i];
    }
    $sum += $splitted_nums[-2] * 5 / 10;
    $sum %= 10;
    $sum = 10 - $sum;
    return $sum == $splitted_nums[-1] ? 1 : 0;
};

1;

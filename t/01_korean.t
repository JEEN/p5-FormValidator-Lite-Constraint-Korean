use strict;
use warnings;
use utf8;
use Test::Base::Less;
use FormValidator::Lite qw/Korean/;
use CGI;

plan tests => 14;

filters {
    query    => [qw/eval/],
    rule     => [qw/eval/],
    expected => [qw/eval/],
};

for my $block (blocks) {
    my $q = CGI->new($block->query);

    my $v = FormValidator::Lite->new($q);
    $v->check(
        $block->rule
    );

    my @expected = $block->expected;
    while (my ($key, $val) = splice(@expected, 0, 2)) {
        is($v->is_error($key), $val, $block->name);
    }
}

done_testing;

__END__

=== HANGUL
--- query: { 'val1' => '한글', 'val2' => 'ascii', 'val3' => '한 글', 'val4' => '한123글', 'val5' => '한a글' }
--- rule
(
    val1 => [qw/HANGUL/],
    val2 => [qw/HANGUL/],
    val3 => [qw/HANGUL/],
    val4 => [qw/HANGUL/],
    val5 => [qw/HANGUL/],
);
--- expected
(
    val1 => 0,
    val2 => 1,
    val3 => 0,
    val4 => 1,
    val5 => 1,
)

=== KTEL
--- query: { 'p1' => '010-000-0000', 'p2' => '02-5555-5555'}
--- rule
(
    p1 => [qw/KTEL/],
    p2 => [qw/KTEL/],
);
--- expected
(
    p1 => 0,
    p2 => 0,
)

=== KZIP
--- query: { 'p1' => '155-004', 'p2' => '02-5555-5555'}
--- rule
(
    p1 => [qw/KZIP/],
    p2 => [qw/KZIP/],
);
--- expected
(
    p1 => 0,
    p2 => 1,
)

=== KBIZ_ID
--- query: { 'p1' => '000-00-00000', 'p2' => '00-000-00000' }
--- rule
(
    p1 => [qw/KBIZ_ID/],
    p2 => [qw/KBIZ_ID/],
)
--- expected
(
    p1 => 0,
    p2 => 1
)

=== KBIZ_ID_STRICT
--- query: { 'p1' => '107-82-06408', 'p2' => '000-00-00000', 'p3' => '00-000-00000' }
--- rule
(
    p1 => [qw/KBIZ_ID_STRICT/],
    p2 => [qw/KBIZ_ID_STRICT/],
    p3 => [qw/KBIZ_ID_STRICT/],
)
--- expected
(
    p1 => 0,
    p2 => 1,
    p3 => 1,
)


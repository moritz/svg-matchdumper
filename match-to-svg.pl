use v6;
BEGIN { @*INC.push: '../svg/lib', 'lib' }
use SVG::MatchDumper;


token fruit     { banana | apple }
token currency  { 'USD' | 'dollar' | 'EUR' | '$' | '€' }

my $x = 'just 20,000 dollar per apple';

if $x ~~ m/:s ((\d+) ** ',') <currency> 'per' <fruit> $ / {
    svg-dump($/, $x);
} else {
    die "no match";
}

# vim: ft=perl6 sw=4 ts=4 expandtab fileencoding=utf8

use v6;
BEGIN { @*INC.push: '../svg/lib' }
use SVG;

my $width   = 400;
my $height  = 300;

multi sub svg-dump(Match $m) {
    my @s = gather {
        svg-dump($m, 0, $width / 2);
    }
    say SVG.serialize(
        'svg' => [
            :width($width),
            :height($height),
            'xmlns'         => 'http://www.w3.org/2000/svg',
            'xmlns:svg'     => 'http://www.w3.org/2000/svg',
            'xmlns:xlink'   => 'http://www.w3.org/1999/xlink',
            :g([
                :transform«translate(0,$height)»,
                @s,
            ]),
        ]
    );
}

# 

multi sub svg-dump(Match $m, $x, $y) {
}

my $x = 'the 1,000,000 man';

if $x ~~ m/ ^ \w+ \s (<[10,]>+) \s \w+ $ / {
    svg-dump($/);
} else {
    die "no match";
}

# vim: ft=perl6 sw=4 ts=4 expandtab fileencoding=utf8

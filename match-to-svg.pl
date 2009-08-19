use v6;
BEGIN { @*INC.push: '../svg/lib' }
use SVG;

my $font-size   = 14;
my $width       = 600;
my $height      = 300;
my $margin      = 10;
our $s;


multi sub svg-dump(Match $m, $orig = ~$m) {
    # XXX $chars should be $m.orig.chars by default,
    # but blocks on RT #68680
    my $chars = $orig.chars;
    my $font-width  = $font-size * 0.6;
    my $scale       = $width / ($font-width * $chars);
    $s              = $width / $chars;
    my @s = gather {
        svg-dump($m, '$/', 1);
    }
    say SVG.serialize(
        'svg' => [
            :width($width + 2 * $margin),
            :height($height + 2 * $margin),
            'xmlns'         => 'http://www.w3.org/2000/svg',
            'xmlns:svg'     => 'http://www.w3.org/2000/svg',
            'xmlns:xlink'   => 'http://www.w3.org/1999/xlink',

            g => [
                :transform("translate($margin,$margin)"),
                'text' => [
                    :font-size($font-size),
                    :font-family<monospace>,
                    :transform("scale($scale,$scale)"),
                    :textLength($width),
                    :x(0),
                    :y($font-size * 1.2),
                    $orig,
                ],
                @s
            ],
        ]
    );
}

multi sub svg-dump(Match $m, Str $path, $y) {
    svg-line(
        :from($m.from),
        :to($m.to),
        :text($path),
        :y($y),
    );

    for $m.caps -> $c {
        my $k = $c.key;
        my $newkey = $k ~~ Int ?? "[$k]" !! "&lt;$k&gt;"; # ugly hack
                                                          # until SVG.pm
                                                          # does some escaping
        svg-dump($c.value, $path ~ $newkey, $y+1);
    }
}

multi sub svg-line(:$from!, :$to!, :$text!, :$y!) {
#    warn [$from, $to, $text, $y].perl;
    take 'rect' => [
        :x($from * $s),
        :width(($to - $from) * $s),
        :y($y * 2 * $font-size + 50),
        :height(2 * $font-size),
        :style('stroke: black; stroke-width: 1; fill: rgb(220,220,220); opacity: 10%'),
    ];
    take 'text' => [
        :x(($from + $to) * $s / 2),
        :y($y * 2 * $font-size + 50 + $font-size),
        :text-anchor<middle>,
        :font-size($font-size),
        :font-family<monospace>,
        :dominant-baseline<middle>,

        $text,
    ];
}

#// # unconfuse vim

token fruit     { banana | apple }
token currency  { 'USD' | 'dollar' | 'EUR' | '$' | '€' }

my $x = 'just 20,000 dollar per apple';

if $x ~~ m/:s ((\d+) ** ',') <currency> 'per' <fruit> $ / {
    svg-dump($/, $x);
} else {
    die "no match";
}

# vim: ft=perl6 sw=4 ts=4 expandtab fileencoding=utf8

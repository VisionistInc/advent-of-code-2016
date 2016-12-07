use strict;
use warnings;

# how many rows to get triangle sides (1 or 3)
my $rows = 3;
     
my $filename = 'input';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

my $tris = 0;
my @buf;
 
while (<$fh>) {
    if (eof) {
        last;
    }

    # get each number from a row
    my @row = split ' ', $_;

    # add each number to buf
    push (@buf, @row);

    # if we have enough numbers to do triangle math
    if (@buf == (3*$rows)) {

        # for each triangle in the numbers we have
        for (my $i = 0; $i < $rows; $i++) {
            my $j = $i + $rows;
            my $k = $j + $rows;
            $tris = $tris + is_tri($buf[$i], $buf[$j], $buf[$k]);
        }
        @buf = ();
    }
}

print "$tris\n";

sub is_tri {
    my $ab = $_[0] + $_[1];
    my $ac = $_[0] + $_[2];
    my $bc = $_[1] + $_[2];
    if (($ab > $_[2]) && ($ac > $_[1]) && ($bc > $_[0])) {
        return 1;
    }
    return 0;
}

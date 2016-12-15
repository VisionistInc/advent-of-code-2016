<?php 

# set for part 1 or 2
#$rehash=0;
$rehash=2016;

$input="qzyelonm";
#$input="abc";

$three="";
$five="";
$count=0;
$i=0;


while ($count < 64)
{
    if (strlen($three) <= $i)
    {
        grow();
    }
    if ($three[$i] != 'z')
    {
        for ($j = ($i + 1); $j <= ($i + 1000); $j++)
        {
            if (strlen($five) <= $j)
            {
                grow();
            }
            if ($three[$i] == $five[$j])
            {
                echo "{$i}\n";
                $count++;
                break;
            }
        }
    }

    ++$i;
}

function grow()
{
    global $input, $three, $five, $rehash;
    $j = strlen($three);
    $val = $input.$j;
    $md5 = md5($val);
    for ($j = 0; $j < $rehash; $j++)
    {
        $md5 = md5($md5);
    }
    $three = $three.match($md5, 3);
    $five = $five.match($md5, 5);
}

function match($str, $num)
{
    $len = strlen($str);
    for ($x = 0; $x < ($len-($num-1)); $x++)
    {
        for ($y = 1; $y < $num; $y++)
        {
            if ($str[$x + $y] != $str[$x])
            {
                break;
            }
            if ($y == ($num - 1))
            {
                return $str[$x];
            }
        }
    }
    # not a valid md5sum char
    return 'z';
}

?> 

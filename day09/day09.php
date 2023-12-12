<?php

$lines = explode("\n", trim(file_get_contents("data.txt")));
$partA = 0;
$partB = 0;

foreach ($lines as $line) {
    $hir = [array_map(fn ($val) => intval($val), explode(" ", $line))];
    $curr = $hir[0];
    $i = 0;

    while (true) {
        $i++;
        $prev = null;
        $prevd = null;
        $changed = false;
        $new = [];
        foreach ($curr as $i => $v) {
            if ($i === 0) {
                $prev = $v;
                continue;
            }
            $d = $v - $prev;
            if ($prevd != $d) {
                $changed = true;
            }
            $new[] = $d;
            $prevd = $d;
            $prev = $v;
        }

        $hir[] = $new;
        $curr = $new;

        if (!$changed) {
            break;
        } 
    }

    $hir = array_reverse($hir);
    $nexth = $hir;
    $p = 0;
    foreach ($nexth as $i => $a) {
        $last = $a[count($a) - 1];
        $nexth[$i][] = $last + $p;
        $p = $last + $p;
    }

    $prevh = $hir;
    $p = 0;
    foreach ($prevh as $i => $a) {
        $first = $a[0];
        array_unshift($prevh[$i], $first - $p);
        $p = $first - $p;
    }

    $historyA = $nexth[count($nexth) - 1];
    $partA += $historyA[count($historyA) - 1];

    $partB += $prevh[count($prevh) - 1][0];
}

echo "Part A: " . $partA . "\n";
echo "Part B: " . $partB . "\n";

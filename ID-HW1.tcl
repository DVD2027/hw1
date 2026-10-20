set id 211547211
set header "# EX_1 Gal Cohen 211547211 Yovel Granot 208237651"
set part1 "$id.part1"
set part2 "$id.part2"

expr {srand($id)}

# ===== Part 1 =====
set N [expr {int(rand()*11) + 10}]

set f1 [open $part1 "w"]
puts $f1 $header
puts $f1 "Number of runs: N = $N"

for {set run 1} {$run <= $N} {incr run} {
    puts $f1 "Run Number: $run"
    puts $f1 "-------------"

    set M [expr {int(rand()*26) + 5}]
    puts $f1 "M = $M"

    set sum 0
    for {set i 0} {$i < $M} {incr i} {
        set val [expr {int(rand()*($id + 1))}]
        puts $f1 $val
        incr sum $val
    }

    set avg [expr {double($sum) / $M}]
    puts $f1 [format "Average = %.1f" $avg]
    puts $f1 ""
}
close $f1

# ===== Part 2 =====
set records {}

set f [open $part1 r]
set lines [split [read $f] "\n"]
close $f

set currentRun ""
set numbers {}
set collecting 0

foreach line $lines {
    set t [string trim $line]

    if {[regexp {^Run Number:\s*(\d+)} $t -> currentRun]} {
        set numbers {}
        set collecting 1
        continue
    }
    if {[string match "M = *" $t]} {
        continue
    }
    if {$collecting && [string is integer -strict $t]} {
        lappend numbers $t
        continue
    }
    if {[regexp {^Average =\s*([0-9.]+)} $t -> avgVal]} {
        set maxVal [lindex [lsort -integer -decreasing $numbers] 0]
        lappend records [list $currentRun $avgVal $maxVal]
        set collecting 0
    }
}

# sort by average (index 1), ascending
set ordered [lsort -real -increasing -index 1 $records]

set f2 [open $part2 "w"]
puts $f2 $header
puts $f2 [format "%-14s%-14s%s" "Run Number" "Average" "Maximum"]
puts $f2 [format "%-14s%-14s%s" "------------" "-------" "-------"]
foreach rec $ordered {
    lassign $rec run avg maxv
    puts $f2 [format "%-14s%-14s%s" $run $avg $maxv]
}
close $f2

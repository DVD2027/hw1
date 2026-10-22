# HW1 - Digital VLSI Design
# Matan Lary 216193292, Ariel Hazoot 331104018

expr { srand(216193292) }               ;# seed random generator 

# ===== Part 1 =====
set fh1 [open 216193292.part1 w]
puts $fh1 "# EX_1 Matan Lary 216193292 Ariel Hazoot 331104018"

set N [expr {10 + int(rand()*11)}]      ;# 10-20
puts $fh1 "Number of runs: N = $N"

for {set i 1} {$i <= $N} {incr i} {
    puts $fh1 "Run Number: $i"
    puts $fh1 "-------------"
    set M [expr {5 + int(rand()*26)}]   ;# 5-30
    puts $fh1 "M = $M"
    set sum 0
    for {set j 0} {$j < $M} {incr j} {
        set num [expr {int(rand()*216193293)}]   ;# 0-216193292
        puts $fh1 $num
        set sum [expr {$sum + $num}]
    }
    set avr [format %.1f [expr {double($sum)/$M}]]
    puts $fh1 "Average = $avr"
    puts $fh1 ""                         ;# blank line between runs
}
close $fh1

# ===== Part 2 =====
set fh1 [open 216193292.part1 r]
set runs {}

while {[gets $fh1 line] >= 0} {                           ;# read part1 line by line
    if {[regexp {^Run Number: (\d+)} $line -> run]} {     ;# encounter new run SSSS
        set max -1
    } elseif {[regexp {^(\d+)$} $line -> num]} {          ;# a line with only a number
        if {$num > $max} {
            set max $num
        }
    } elseif {[regexp {^Average = (.+)$} $line -> avr]} { ;# end of run
        lappend runs [list $run $avr $max]
    }
}
close $fh1

set sorted [lsort -real -index 1 $runs]                   ;# sort by average (index 1)

set fh2 [open 216193292.part2 w]
puts $fh2 "# EX_1 Matan Lary 216193292 Ariel Hazoot 331104018"
puts $fh2 "Run Number    Average       Maximum"
puts $fh2 "------------  -------       -------"
foreach item $sorted {
    puts $fh2 [format {%-14s%-14s%s} [lindex $item 0] [lindex $item 1] [lindex $item 2]]
}
close $fh2


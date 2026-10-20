# HW1 - Digital VLSI Design
# Part 1 - Running Average

set ID 315311175

expr {srand($ID)}
set N [expr {int(rand() * 11) + 10}]
set filename "$ID.part1"
set fh [open $filename w]
puts $fh "# EX_1 Yuval Hatuka 315311175 Meryam Awad 211913397"
puts $fh "Number of runs: N = $N"
for {set i 1} {$i <= $N} {incr i} {
    puts $fh "Run Number: $i"
    puts $fh "--------------"
    set M [expr {int(rand() * 26) + 5}]
    puts $fh "M = $M"
    set sum 0
    for {set j 1} {$j <= $M} {incr j} {
        set num [expr {int(rand() * ($ID + 1))}]
        puts $fh $num
        set sum [expr {$sum + $num}]
    }
    set average [expr {double($sum) / $M}]
    puts $fh [format "Average = %.1f" $average]
    if {$i < $N} {
       puts $fh ""
}
}
close $fh


# Part 2 - Parse and analyze the file

set fh [open $filename r]
set lines {}

while {[gets $fh line] >= 0} {
    lappend lines $line
}

close $fh
set results {}
set run 0
set maxNum 0
foreach line $lines {
    if {[regexp {^Run Number: ([0-9]+)} $line -> run]} {
        set maxNum 0
    }
    if {[regexp {^[0-9]+$} $line]} {
        if {$line > $maxNum} {
            set maxNum $line
        }
    }
    if {[regexp {^Average = ([0-9.]+)} $line -> avg]} {
        lappend results [list $avg $run $maxNum]
    }
}
set sortedResults [lsort -real -index 0 $results]
set filename2 "$ID.part2"
set fh2 [open $filename2 w]
puts $fh2 "# EX_1 Yuval Hatuka 315311175 Meryam Awad 211913397"
puts $fh2 [format "%-14s %-14s %s" "Run Number" "Average" "Maximum"]
puts $fh2 [format "%-14s %-14s %s" "----------" "-------" "-------"]

foreach item $sortedResults {
    set avg [lindex $item 0]
    set avg [format "%.1f" $avg]
    set run [lindex $item 1]
    set maxNum [lindex $item 2]
    puts $fh2 [format "%-14s %-14s %s" $run $avg $maxNum]
}
close $fh2

set id 318903382
expr {srand($id)}
set N [expr {int(rand() * 11) + 10}]

set fh [open "${id}.part1" w]

puts $fh "# EX_1 Guy Cohen 318903382 Snir Cohen 322401282"
puts $fh "Number of runs: N = $N"
for {set i 1} {$i <= $N} {incr i} {
    set M [expr {int(rand() * 26) + 5}]
    set sum 0
    puts $fh "Run Number: $i"
    puts $fh "-------------"
    puts $fh "M = $M"
    for { set j 1 } {$j <= $M} {incr j} {
        set num [expr {int(rand()*($id + 1))}]
        puts $fh $num
        set sum [expr {$sum + $num}]
    }
    set avg [format "%.1f" [expr {double($sum) / $M}]]
    puts $fh "Average = $avg"
    if {$i < $N} {
        puts $fh ""
    }
}   
close $fh


set fh [open "${id}.part1" r]
set results {}
while {[gets $fh line] >= 0} {
    if {[regexp {^Run Number: ([0-9]+)$} $line match runNumber]} {
    }
    if {[regexp {^M = ([0-9]+)$} $line match M]} {
        set maxNum 0
        for {set j 0} {$j < $M} {incr j} {
            gets $fh num
            if {$num > $maxNum} {
                set maxNum $num
            }
        }
    }
    if {[regexp {^Average = ([0-9]+[.][0-9]+)$} $line match average]} {
        lappend results [list $runNumber $average $maxNum]
}
}
close $fh
set sortedResults [lsort -real -index 1 $results]

set fh [open "${id}.part2" w]
puts $fh "# EX_1 Guy Cohen 318903382 Snir Cohen 322401282"
puts $fh [format "%-14s%-14s%s" "Run Number" "Average" "Maximum"]
puts $fh [format "%-14s%-14s%s" "------------" "-------" "-------"]
foreach run $sortedResults {
    set runNumber [lindex $run 0]
    set average [lindex $run 1]
    set maxNum [lindex $run 2]
    puts $fh [format "%-14s%-14s%s" $runNumber $average $maxNum]
}
close $fh
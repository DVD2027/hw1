# HW1 - Digital VLSI Design
# Practice: Calculate Average
# HW1 - Part 1
# Random number generation

set ID 213601594

# Initialize random generator
expr {srand($ID)}

# Generate N between 10 and 20
set N [expr {int(rand() * 11) + 10}]
set filename "$ID.part1"
set fh [open $filename w]
puts $fh "# EX_1 RAZI ZOABI 213601594 Yosef Shekh Yosef 322673591"
puts $fh "Number of runs: N = $N"

for {set run 1} {$run <= $N} {incr run} {

    puts $fh "Run Number: $run"
    puts $fh "-------------"

    set M [expr {int(rand() * 26) + 5}]
    puts $fh "M = $M"

    set sum 0

    for {set i 1} {$i <= $M} {incr i} {
        set num [expr {int(rand() * ($ID + 1))}]
        puts $fh $num
        set sum [expr {$sum + $num}]
    }

    set average [format "%.1f" [expr {double($sum) / $M}]]
    puts $fh "Average = $average"
    puts $fh ""
}
close $fh
# HW1 - Part 2
# Read Part 1 file

set inputFile [open "$ID.part1" r]
set results {}
set maxNum -1

while {[gets $inputFile line] >= 0} {

    if {[regexp {^Run Number: ([0-9]+)$} $line match runNumber]} {
        set maxNum -1
    }

    if {[regexp {^[0-9]+$} $line]} {
        if {$line > $maxNum} {
            set maxNum $line
        }
    }

    if {[regexp {^Average = (.+)$} $line match average]} {
    lappend results [list $runNumber $average $maxNum]
}
}
close $inputFile
set sortedResults [lsort -real -index 1 $results]

set outputFile [open "$ID.part2" w]

puts $outputFile "# EX_1 RAZI ZOABI 213601594 Yosef Shekh Yosef 322673591"
puts $outputFile "Run Number    Average       Maximum"
puts $outputFile "------------  -------       -------"
foreach result $sortedResults {
    set runNumber [lindex $result 0]
    set average [lindex $result 1]
    set maximum [lindex $result 2]

   puts $outputFile [format "%-14s%-14s%s" $runNumber $average $maximum]
   }
close $outputFile

expr { srand(331624437) }
set N [expr { int(rand()*11) + 10 }]
set part1 [open "331624437.part1" w]
puts $part1 "# EX_1 Yoav Shayovich 331624437 Avishay Fridman 216249334"
puts $part1 "Number of runs: N = $N"
for { set i 1 } { $i <= $N } { incr i } {
    puts $part1 "Run Number: $i"
    puts $part1 "-------------"
    set M [expr { int(rand()*26) + 5 }]
    puts $part1 "M = $M"
    set sum 0
    for { set j 0 } { $j < $M } { incr j } {
        set v [expr { int(rand()*(331624437 + 1))}]
        puts $part1 $v
        set sum [expr {$sum + double($v)}] 
        # We made v double for sum to be double because it becomes extremely large

    }
    set avg [expr { $sum / $M}]
    puts $part1 "Average = [format "%.1f" $avg]"
    # This format allows us to take only the first decimal digit of the average like in the assignment example
    if {$i < $N} {
        puts $part1 ""
    }
    # Putting the if here is just for the last run where according to the assignment example there isn't a gap after the run prints
 }
close $part1

set part1_read [open "331624437.part1" r]
set runs_data {}
set c_run ""
set c_max -1
while { [gets $part1_read line] >= 0 } { 
    if { [string length $line] > 0 } {
        set word0 [lindex $line 0] 
        # we take the first word of the line
        if { $word0 == "Run" } {
            # The line is "Run Number: ..." so the num must be at index 2
            set c_run [lindex $line 2]
            set c_max -1 
        } elseif {$word0 == "Average"} {
            # we're at "Average = ..." so the num itself is at index 2
            set avg [lindex $line 2]
            lappend runs_data [list $c_run $avg $c_max]
        } elseif { [string is integer -strict $word0] } {
            # check if the first word is a number, if so it's one of the random ones
            if { $word0 > $c_max } {
                set c_max $word0
            }
        }
    }
 }
close $part1_read

set sorted_runs [lsort -real -index 1 $runs_data]
# now we sort by the Average (index 1), ascending
set part2 [open "331624437.part2" w]

puts $part2 "# EX_1 Yoav Shayovich 331624437 Avishay Fridman 216249334"
puts $part2 [format "%-14s%-14s%s" "Run Number" "Average" "Maximum"]
puts $part2 [format "%-14s%-14s%s" "------------" "-------" "-------"]

foreach run $sorted_runs {
    set num [lindex $run 0]
    set avg [lindex $run 1]
    set max [lindex $run 2]
    
    puts $part2 [format "%-14s%-14s%s" $num $avg $max]
}
close $part2
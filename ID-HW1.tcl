# EX_1 Yaron Barooh 326878725 Yaki Rabinyan 322606997

set ID 326878725

# Seed the representative ID
expr {srand($ID)}

# Random number between (10-20)
set N [expr {int(rand() * 11) + 10}]

# Open output file
set out [open "$ID.part1" w]

puts $out "# EX_1 Yaron Barooh 326878725 Yaki Rabinyan 322606997"
puts $out "Number of runs: N = $N"

# Generate runs
for {set i 1} {$i <= $N} {incr i} {

    # Random M between 5 and 30
    set M [expr {int(rand() * 26) + 5}]

    puts $out "Run Number: $i"
    puts $out "-------------"
    puts $out "M = $M"

    set sum 0

    # Generate M random numbers
    for {set j 0} {$j < $M} {incr j} {

        set num [expr {int(rand() * ($ID + 1))}]

        puts $out $num

        set sum [expr {$sum + $num}]
    }

    # Calculate average
    set avg [format "%.1f" [expr {double($sum) / $M}]]

    puts $out "Average = $avg"
    puts $out ""
}

close $out





# =====================================
# PART 2 - Parse and analyze the file
# =====================================

# Open Part 1 file for reading
set input [open "$ID.part1" r]

# List to store the results
set results {}

# Read the file line by line
while {[gets $input line] >= 0} {

    # Find the run number
    if {[regexp {^Run Number: ([0-9]+)} $line match run]} {
        set max 0
    }

    # Find the number of values
    if {[regexp {^M = ([0-9]+)} $line match M]} {

        # Read M numbers and find the maximum
        for {set j 0} {$j < $M} {incr j} {
            gets $input number

            if {$number > $max} {
                set max $number
            }
        }
    }

    # Find the average
    if {[regexp {^Average = (.+)} $line match avg]} {
        lappend results [list $run $avg $max]
    }
}

close $input

# Sort runs by average in ascending order
set results [lsort -real -index 1 $results]

# Open Part 2 output file
set output [open "$ID.part2" w]

# Write header
puts $output "# EX_1 Yaron Barooh 326878725 Yaki Rabinyan 322606997"

puts $output [format "%-14s%-14s%s" "Run Number" "Average" "Maximum"]
puts $output [format "%-14s%-14s%s" "------------" "-------" "-------"]

# Write sorted results
foreach item $results {

    set run [lindex $item 0]
    set avg [lindex $item 1]
    set max [lindex $item 2]

    puts $output [format "%-14s%-14s%s" $run $avg $max]
}

close $output

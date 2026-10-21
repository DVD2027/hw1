
# HW1 - Digital VLSI Design
# EX_1 - Ori Braymok 314992447 & Adi Green 324965946

set ID 314992447

# Initialize the random number generator
expr {srand($ID)}

# Generate number of runs (10-20)
set N [expr {int(rand() * 11) + 10}]

# Open output file
set file [open "${ID}.part1" w]

# Write header
puts $file "# EX_1 Ori Braymok 314992447 Adi Green 324965946"
puts $file "Number of runs: N = $N"


for {set i 1} {$i <= $N} {incr i} {

    # Generate M between 5 and 30
    set M [expr {int(rand() * 26) + 5}]

    puts $file "Run Number: $i"
    puts $file "-------------"
    puts $file "M = $M"

    # Initialize sum
    set sum 0

    for {set j 0} {$j < $M} {incr j} {

        # Generate random number between 0 and ID
        set num [expr {int(rand() * ($ID + 1))}]

        puts $file $num

        set sum [expr {$sum + $num}]
    }

    # Calculate average
    set avg [expr {double($sum) / $M}]
    puts $file "Average = $avg"
    puts $file ""

}
close $file


# =====================================
# Part B.2 - Parse and analyze the file

set input [open "${ID}.part1" r]

# List to store results
set results {}

# Read the file line by line
while {[gets $input line] >= 0} {

    # Detect run number
    if {[regexp {^Run Number: ([0-9]+)$} $line match run]} {
        set maximum 0
    }

    # Detect a random number
    if {[regexp {^[0-9]+$} $line]} {
        if {$line > $maximum} {
            set maximum $line
        }
    }

    # Detect average
    if {[regexp {^Average = ([0-9.]+)$} $line match avg]} {
        lappend results [list $run $avg $maximum]
    }
}

close $input


# Sort results by average (ascending)
set sorted_results [lsort -real -index 1 $results]

# Open Part 2 output file
set output [open "${ID}.part2" w]

# Write header
puts $output "# EX_1 Ori Braymok 314992447 Adi Green 324965946"
puts $output "Run Number    Average       Maximum"
puts $output "------------  -------       -------"

# Write sorted results
foreach result $sorted_results {

    set run [lindex $result 0]
    set avg [lindex $result 1]
    set maximum [lindex $result 2]

    puts $output [format "%-14d%-14.1f%d" $run $avg $maximum]
}

# Close output file
close $output

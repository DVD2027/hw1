
# HW1 - Digital VLSI Design
# Gil Artsev 216293563
# Idan Rozen 330841131

# Student ID
set id 216293563

# Initialize random generator
expr {srand($id)}

# Generate N between 10 and 20
set N [expr {int(rand() * 11) + 10}]

# Open output file
set filename "${id}.part1"
set file [open $filename w]

# Write header
puts $file "# EX_1 Gil Artsev 216293563, Idan Rozen 330841131"
puts $file "Number of runs: N = $N"

# Loop over N runs
for {set i 1} {$i <= $N} {incr i} {

    # Generate M between 5 and 30
    set M [expr {int(rand() * 26) + 5}]

    puts $file "Run Number: $i"
    puts $file "-------------"
    puts $file "M = $M"

    # Initialize sum
    set sum 0

    # Generate M random numbers
    for {set j 0} {$j < $M} {incr j} {

        set num [expr {int(rand() * ($id + 1))}]

        puts $file $num

        set sum [expr {$sum + $num}]
    }

    # Calculate average
    set average [expr {double($sum) / $M}]

    puts $file "Average = $average"
    puts $file ""
}

# Close output file
close $file

puts "Part 1 completed: $filename"


# ==========================================
# Part 2 - Parse, Sort and Save Results
# ==========================================

# Open Part 1 output for reading
set inputFile [open "${id}.part1" r]

# Store results as {run average maximum}
set results {}

set runNumber 0
set maxNumber 0

# Read the file line by line
while {[gets $inputFile line] >= 0} {

    # Detect a new run
    if {[regexp {^Run Number: ([0-9]+)$} $line -> run]} {
        set runNumber $run
        set maxNumber 0
    }

    # Detect a line containing only a number
    if {[regexp {^[0-9]+$} $line]} {
        if {$line > $maxNumber} {
            set maxNumber $line
        }
    }

    # Detect the average and save the run
    if {[regexp {^Average = (.+)$} $line -> avg]} {
        lappend results [list $runNumber $avg $maxNumber]
    }
}

close $inputFile

# Sort by average (ascending)
set results [lsort -real -index 1 $results]

# Open Part 2 output file
set outputFile [open "${id}.part2" w]

# Write header
puts $outputFile "# EX_1 Gil Artsev 216293563, Idan Rozen 330841131"
puts $outputFile [format "%-14s%-22s%s" "Run Number" "Average" "Maximum"]
puts $outputFile [format "%-14s%-22s%s" "------------" "-------" "-------"]

# Write sorted results
foreach result $results {

    set run [lindex $result 0]
    set avg [lindex $result 1]
    set max [lindex $result 2]
    puts $outputFile [format "%-14s%-22s%s" $run $avg $max]
}

close $outputFile

puts "Part 2 completed: ${id}.part2"


# EX_1 Orianne Sprecher 211693585 Shira Dan 212208607

set id 211693585
set header "# EX_1 Orianne Sprecher 211693585 Shira Dan 212208607"
set part1File "${id}.part1"
set part2File "${id}.part2"

# Seed the random number generator
expr {srand($id)}

# ---------- Part One ----------

# Generate a random run count from 10 to 20
set N [expr {10 + int(rand() * 11)}]

# Open the first file for writing
set out [open $part1File w]

# Write the header and number of runs
puts $out $header
puts $out "Number of runs: N = $N"

for {set run 1} {$run <= $N} {incr run} {
    # Generate a random value count from 5 to 30
    set M [expr {5 + int(rand() * 26)}]

    # Write the run information
    puts $out "Run Number: $run"
    puts $out "-------------"
    puts $out "M = $M"

    # Reset the sum for this run
    set sum 0

    for {set i 0} {$i < $M} {incr i} {
        # Generate an integer from 0 to the ID, inclusive
        set value [expr {int(rand() * ($id + 1))}]

        # Write the value and add it to the sum
        puts $out $value
        set sum [expr {$sum + $value}]
    }

    # Calculate the average using floating-point division
    set average [expr {double($sum) / $M}]

    # Write the average with one decimal place
    puts $out [format "Average = %.1f" $average]
    puts $out ""
}

close $out

# ---------- Part Two ----------

# Open the first file for reading
set in [open $part1File r]

# Read the header from the file
gets $in fileHeader

# Each record contains: run number, average, maximum
set records {}

# Read each line until the end of the file
while {[gets $in line] >= 0} {
    # Detect a new run and extract its number
    if {[regexp {^Run Number: ([0-9]+)$} $line -> runNumber]} {
        # Reset the maximum for this run
        set maximum -1
    } elseif {[regexp {^[0-9]+$} $line]} {
        # Update the maximum if the current value is larger
        if {$line > $maximum} {
            set maximum $line
        }
    } elseif {[regexp {^Average = (.+)$} $line -> runAverage]} {
        # Store the completed run's information
        lappend records [list $runNumber $runAverage $maximum]
    }
}

close $in

# Sort numerically by average in ascending order
set records [lsort -real -index 1 $records]

# Open the second file for writing
set out [open $part2File w]

# Write the header
puts $out $fileHeader

# Write the column headings and separators
puts $out [format "%-12s  %-12s  %s" "Run Number" "Average" "Maximum"]
puts $out [format "%-12s  %-12s  %s" "------------" "-------" "-------"]

# Write the sorted runs
foreach record $records {
    # Extract the fields from each record
    lassign $record runNumber runAverage maximum

    # Write one formatted table row
    puts $out [format "%-12s  %-12s  %s" $runNumber $runAverage $maximum]
}

puts $out ""
close $out
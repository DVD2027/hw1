
# ================================================================
# HW1 - The Tool Command Language (Tcl)
# Part 1: Generate random values and calculate averages
# Part 2: Read the file, find maximums, and sort by average
# ================================================================

# Student details (representative and partner)
set id "214068843"
set full_name "Hadas Ram"
set partner_id "206663437"
set partner_name "Rotem Sillam"

# Use the same header in both output files
set header "# EX_1 $full_name $id $partner_name $partner_id"

# ============================ PART 1 ============================

# Convert the ID from a string to a decimal integer
scan $id "%d" seed

# Initialize the random number generator with the ID
expr {srand($seed)}

# Randomly choose N in the inclusive range 10..20
set N [expr {10 + int(rand() * 11)}]

# Open the Part 1 file for writing
set fh [open "${id}.part1" w]

# Write the file header
puts $fh $header
puts $fh "Number of runs: N = $N"

# Repeat the experiment N times
for {set run 1} {$run <= $N} {incr run} {

    # Randomly choose M between 5 and 30
    set M [expr {5 + int(rand() * 26)}]

    # Reset the sum for each run
    set sum 0

    # Write the run information
    puts $fh "Run Number: $run"
    puts $fh "-------------"
    puts $fh "M = $M"

    # Generate M random numbers
    for {set j 0} {$j < $M} {incr j} {

        # Generate a random integer between 0 and ID
        set number [expr {int(rand() * ($seed + 1))}]

        # Write the random number to the file
        puts $fh $number

        # Add the random number to the sum
        set sum [expr {$sum + $number}]
    }

    # Calculate the average using floating-point division
    set average [expr {double($sum) / $M}]

    # Write the average and an empty line
    puts $fh "Average = $average"
    puts $fh ""
}

# Close the Part 1 output file
close $fh


# ============================ PART 2 ============================

# Open the Part 1 file for reading
set input [open "${id}.part1" r]

# Read the first line (header) from the file
set file_header [gets $input]

# Create an empty list to store the results
# Each record will contain: run number, average, maximum
set results {}

# Initialize the maximum value
set maximum -1

# Read the input file line by line
while {[gets $input line] >= 0} {

    # Check if the line contains a run number
    if {[regexp {^Run Number: ([0-9]+)$} $line match run_number]} {

        # Reset the maximum for the new run
        set maximum -1

    # Check if the line contains a random number
    } elseif {[regexp {^[0-9]+$} $line]} {

        # Update the maximum if the number is larger
        if {$line > $maximum} {
            set maximum $line
        }

    # Check if the line contains an average
    } elseif {[regexp {^Average = (.+)$} $line match run_average]} {

        # Store run number, average and maximum together
        lappend results [list $run_number $run_average $maximum]
    }
}

# Close the input file
close $input

# Sort the records by average in ascending numerical order
# Index 1 represents the average in each record
set sorted [lsort -real -index 1 $results]

# Set the minimum width of the average column
set avg_width 14

# Adjust the width if an average has many digits
foreach record $sorted {

    # Get the average from the current record
    set width_needed [expr {[string length [lindex $record 1]] + 2}]

    # Increase the width if necessary
    if {$width_needed > $avg_width} {
        set avg_width $width_needed
    }
}

# Define the output table formatting
# First column: 14 characters, left aligned
# Second column: variable width, left aligned
# Third column: maximum value
set row_format "%-14s%-${avg_width}s%s"

# Open the Part 2 file for writing
set output [open "${id}.part2" w]

# Write the header and column names
puts $output $file_header
puts $output [format $row_format "Run Number" "Average" "Maximum"]
puts $output [format $row_format "------------" "-------" "-------"]

# Write the sorted results
foreach record $sorted {

    # Extract the three values from the current record
    lassign $record run_number run_average maximum

    # Write one formatted row to the output file
    puts $output [format $row_format $run_number $run_average $maximum]
}

# Write an empty line at the end
puts $output ""

# Close the Part 2 output file
close $output

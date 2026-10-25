
# ================================================================
# HW1 - The Tool Command Language (Tcl)
# Part 1: Generate random numbers and calculate averages
# Part 2: Parse the file, find maximums, and sort by average
# ================================================================

# Personal details
set id "214068843"
set full_name "Hadas Ram"
set partner_id "206663437"
set partner_name "Rotem Sillam"

# Create the header for both output files
set header "# EX_1 $full_name $id $partner_name $partner_id"


# ============================ PART 1 ============================

# Convert ID to a decimal integer
scan $id "%d" seed

# Initialize the random number generator using the ID
expr {srand($seed)}

# Generate N between 10 and 20
set N [expr {10 + int(rand() * 11)}]

# Open the Part 1 output file
set fh [open "${id}.part1" w]

# Write the header and number of runs
puts $fh $header
puts $fh "Number of runs: N = $N"

# Perform N runs
for {set run 1} {$run <= $N} {incr run} {

    # Generate M between 5 and 30
    set M [expr {5 + int(rand() * 26)}]

    # Reset the sum for each run
    set sum 0

    # Write run information
    puts $fh "Run Number: $run"
    puts $fh "-------------"
    puts $fh "M = $M"

    # Generate M random numbers
    for {set j 0} {$j < $M} {incr j} {

        # Generate a random integer between 0 and ID
        set number [expr {int(rand() * ($seed + 1))}]

        # Write the random number
        puts $fh $number

        # Add the number to the sum
        set sum [expr {$sum + $number}]
    }

    # Calculate the average using floating-point division
    # Format the average with exactly one decimal place
    set average [format "%.1f" [expr {double($sum) / $M}]]

    # Write the average
    puts $fh "Average = $average"

    # Add an empty line between runs
    puts $fh ""
}

# Close the Part 1 file
close $fh


# ============================ PART 2 ============================

# Open the Part 1 file for reading
set input [open "${id}.part1" r]

# Read the header from Part 1
set file_header [gets $input]

# Create an empty list for the results
# Each record contains: run number, average, maximum
set results {}

# Initialize the maximum
set maximum -1

# Read the file line by line
while {[gets $input line] >= 0} {

    # Check if the line contains a run number
    if {[regexp {^Run Number: ([0-9]+)$} $line match run_number]} {

        # Reset maximum for the new run
        set maximum -1

    # Check if the line contains a random number
    } elseif {[regexp {^[0-9]+$} $line]} {

        # Update maximum if the current number is larger
        if {$line > $maximum} {
            set maximum $line
        }

    # Check if the line contains an average
    } elseif {[regexp {^Average = (.+)$} $line match run_average]} {

        # Save run number, average and maximum
        lappend results [list $run_number $run_average $maximum]
    }
}

# Close the input file
close $input

# Sort records by average in ascending numerical order
# Index 1 is the average in each record
set sorted [lsort -real -index 1 $results]

# Define fixed-width columns exactly as in the example
# First column: 14 characters
# Second column: 14 characters
# Third column: remaining text
set row_format "%-14s%-14s%s"

# Open the Part 2 output file
set output [open "${id}.part2" w]

# Write the header
puts $output $file_header

# Write the column titles
puts $output [format $row_format "Run Number" "Average" "Maximum"]

# Write the separator line
puts $output [format $row_format "------------" "-------" "-------"]

# Write the sorted results
foreach record $sorted {

    # Extract the values from the record
    lassign $record run_number run_average maximum

    # Write the formatted row
    puts $output [format $row_format $run_number $run_average $maximum]
}

# Add an empty line at the end
puts $output ""

# Close the Part 2 file
close $output

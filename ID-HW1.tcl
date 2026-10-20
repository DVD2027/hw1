# HW1 - Digital VLSI Design
# May Ohayon - 212047922
# Roni Or - 209762376
# Language: Tcl

# Part 1 - Random Number Generation
set id 212047922

# Initialize the random number generator
expr {srand($id)}

# Generate the number of runs (10 to 20)
set N [expr {int(rand() * 11) + 10}]

# Open the output file for Part 1
set outfile [open "${id}.part1" w]

# Write the header
puts $outfile "# EX_1 May Ohayon 212047922 Roni Or 209762376"
puts $outfile "Number of runs: N = $N"

# Loop through N runs
for {set i 1} {$i <= $N} {incr i} {

    puts $outfile "Run Number: $i"
    puts $outfile "-------------"

    # Generate M (5 to 30)
    set M [expr {int(rand() * 26) + 5}]
    puts $outfile "M = $M"

    set sum 0

    # Generate M random numbers
    for {set j 1} {$j <= $M} {incr j} {
        set value [expr {int(rand() * ($id + 1))}]
        puts $outfile $value
        set sum [expr {$sum + $value}]
    }

    # Calculate the average
    set average [expr {double($sum) / $M}]
    puts $outfile "Average = $average"
    puts $outfile ""
}

# Close the output file
close $outfile

# Part 2 - Parse and analyze the file

# Open Part 1 file for reading
set infile [open "${id}.part1" r]

# Read the first line
set header [gets $infile]

# Display the header
puts "Header read: $header"
# Read the number of runs from the file
set runs_line [gets $infile]

# Extract N from the line
scan $runs_line "Number of runs: N = %d" runs_from_file

puts "Runs read from file: $runs_from_file"
# Read all runs from the file
# Store parsed results for sorting
set results {}
for {set i 1} {$i <= $runs_from_file} {incr i} {

    # Read run information
    set run_line [gets $infile]
    set separator [gets $infile]
    set m_line [gets $infile]

    scan $run_line "Run Number: %d" run_number
    scan $m_line "M = %d" m_from_file

    # Find the maximum value
    set max_value -1

    for {set j 1} {$j <= $m_from_file} {incr j} {
        set value_line [gets $infile]
        scan $value_line "%d" number

        if {$number > $max_value} {
            set max_value $number
        }
    }

    # Read the average
    set average_line [gets $infile]
    scan $average_line "Average = %f" average_from_file
    lappend results [list $average_from_file $run_number $max_value]

    puts "Run $run_number: Average = $average_from_file, Maximum = $max_value"

    # Skip the empty line between runs
    gets $infile
}

close $infile

puts "Collected [llength $results] runs"

# Sort runs by average (ascending)
set sorted_results [lsort -real -index 0 $results]

# Display sorted run numbers
puts "Sorted run numbers:"
foreach entry $sorted_results {
    puts [lindex $entry 1]
}

# Create Part 2 output file
set outfile2 [open "${id}.part2" w]
# Write Part 2 header
puts $outfile2 "# EX_1 May Ohayon 212047922 Roni Or 209762376"
puts $outfile2 "Run Number    Average       Maximum"
puts $outfile2 "------------  -------       -------"

# Write sorted results to Part 2
foreach entry $sorted_results {

    set average [lindex $entry 0]
    set run_number [lindex $entry 1]
    set max_value [lindex $entry 2]

    # Format columns
    set avg_field [format "%-14s" $average]
    if {[string length $average] >= 14} {
        append avg_field " "
    }

    puts $outfile2 "[format %-14s $run_number]${avg_field}$max_value"
}

# Add final empty line and close the file
puts $outfile2 ""
close $outfile2
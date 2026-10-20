
# EX_1 Michael Birenboim 207813114 and Igor Perets 323454405

# Seed the random number
expr {srand(207813114)}

# Random N 
set N [expr {int(rand() * 11) + 10}]

# Open the output file
set filename "207813114.part1"
set file [open $filename "w"]

# Write the header
puts $file "# EX_1 Michael Birenboim 207813114 and Igor Perets 323454405"
puts $file "Number of runs: N = $N"

# Run the loop N times
for {set run 1} {$run <= $N} {incr run} {
   if { $run != 1 } {
    puts $file ""
   }
    puts $file "Run Number: $run"
    puts $file "-------------"

    # Random M in the range
    set M [expr {int(rand() * 26) + 5}]
    puts $file "M = $M"

    set sum 0

    # Generate M random integers in the range
    for {set i 0} {$i < $M} {incr i} {
        set number [expr {int(rand() * 207813115)}]
        puts $file $number
        set sum [expr {$sum + $number}]
    }

    # Calculate and write the average
    set average [expr {double($sum) / $M}]
    puts $file [format "Average = %.1f" $average]
}

# Close the output file
close $file


# Part2:

# Open the part1 file for reading
set input_filename "207813114.part1"
set input_file [open $input_filename "r"]

# Read the header from the input file
gets $input_file header

# Open the part2 output file
set output_filename "207813114.part2"
set output_file [open $output_filename "w"]

# Write the header to the output file
puts $output_file $header
puts $output_file "Run Number    Average       Maximum"
puts $output_file "------------  -------       -------"

# Store each run as a list:
set runs {}

set current_run ""
set maximum ""

# Read the input file line by line

while {[gets $input_file line] >= 0} {

    # Identify the beginning of a new run
    if {[regexp {^Run Number: ([0-9]+)} $line match run_number]} {
        set current_run $run_number
        set maximum ""
    } elseif {[regexp {^Average = ([0-9]+\.[0-9]+)} $line match average]} {

        # Save the run number, average and maximum
        lappend runs [list $current_run $average $maximum]

        set current_run ""
        set maximum ""
    } elseif {[regexp {^[0-9]+$} $line]} {

        # Update the maximum number
        if {$maximum eq "" || $line > $maximum} {
            set maximum $line
        }
    }
}


# Close the input file
close $input_file

# Sort the runs by average in ascending numerical order
set sorted_runs [lsort -real -index 1 $runs]

# Write the sorted results
foreach run $sorted_runs {
    set run_number [lindex $run 0]
    set average [lindex $run 1]
    set maximum [lindex $run 2]

    puts $output_file [format "%-14s%-15s%s" \
        $run_number $average $maximum]
}

# Close the output file
close $output_file

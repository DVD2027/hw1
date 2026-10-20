# EX_1 Ido Israeli 322698283 Avital Burg 211419890

#------------------------------------------------------------------------
# PART 1: Calculate a running average
#------------------------------------------------------------------------
set partner1_name "Ido Israeli"
set partner1_id   "322698283"
set partner2_name "Avital Burg"
set partner2_id "211419890"

# The representative ID
set rep_id $partner1_id

# Seed the pseudo-random generator 
expr { srand($rep_id) }


# Help functions for Random integer in range [min, max]
proc rand_range {min max} {
    return [expr { $min + int(rand() * ($max - $min + 1)) }]
}


proc rand_val {max_val} {
    # Adding 1.0 ensures representative ID is inclusive without integer overflow
    return [expr { int(rand() * (wide($max_val) + 1)) }]
}

# Determine number of runs N
set N [rand_range 10 20]

# Open the output file: <ID_NUMBER>.part1
set outfile "${rep_id}.part1"
set fh [open $outfile "w"]

# Header line
puts $fh "# EX_1 $partner1_name $partner1_id $partner2_name $partner2_id"
puts $fh "Number of runs: N = $N"

# Execution loop for N runs
for {set i 1} {$i <= $N} {incr i} {
    # Determine M
    set M [rand_range 5 30]
    puts $fh "Run Number: $i"
    puts $fh "-------------"
    puts $fh "M = $M"
    set sum 0.0

    # Generate M random numbers in range [0, ID]
    for {set j 0} {$j < $M} {incr j} {
        set val [rand_val $rep_id]
        puts $fh $val
        set sum [expr { $sum + $val }]
    }

    # Calculate average
    set avg [format "%.1f" [expr { $sum / double($M) }]]
    puts $fh "Average = $avg\n"
}

close $fh

# Just to make sure it runs successfully
puts "Successfully generated $outfile"


#------------------------------------------------------------------------
# PART 2: Parse and analyze the file
#------------------------------------------------------------------------

# Define the source input file and target output file 
set infile  "${rep_id}.part1"
set outfile "${rep_id}.part2"

# Initialize an empty list where each completed run will be stored here with run_number and  average maximum
set runs_data [list]

# Open Part 1 output file
set in_fh [open $infile "r"]

# State variables for the parsing loop:
# Stores the run index currently being parsed.
# Tracks the highest numeric value seen in the current run.
# Initialized current max to -1 because all generated random values in Part 1 are positive.
set current_run ""
set current_max -1

# Read input file line-by-line
# Return the number of characters read.
while {[gets $in_fh line] >= 0} {
    # Strip leading and trailing whitespace.
    set line [string trim $line] ;
    
    # Detect run boundary: Match lines starting with "Run Number: <integer>"
    if {[regexp {^Run Number:\s*(\d+)} $line match r_num]} {
        set current_run $r_num
        set current_max -1 ;# Reset running maximum for the new run block

    # Detect run conclusion: Match lines starting with "Average = <float>"
    } elseif {[regexp {^Average\s*=\s*([0-9.]+)} $line match avg_val]} {
        # If currently tracking an active run, store the parsed record: {run_num, average, maximum}
        if {$current_run ne ""} {
            lappend runs_data [list $current_run $avg_val $current_max]
            set current_run "" ;
        }

    # Detect data values: Match lines containing strictly digits from start (^) to end ($)
    } elseif {[regexp {^\d+$} $line]} {
        # Cast the line to a 64-bit wide integer to safely handle large ID-scale numbers without 32-bit overflow
        set num [expr {wide($line)}]
        
        # Update the maximum value found so far for the active run
        if {$num > $current_max} {
            set current_max $num
        }
    }
}


close $in_fh

# Sort the extracted runs in ascending order based on the calculated average
set sorted_runs [lsort -real -increasing -index 1 $runs_data]

# Open the target file <ID_NUMBER>.part2
set out_fh [open $outfile "w"]

# Header line
puts $out_fh "# EX_1 $partner1_name $partner1_id $partner2_name $partner2_id"

# Format and write the table column headers and dashed separator lines matching the required template:
#  Left-aligned string padded to 14 characters wide.
#  Prints the final column with default width.
puts $out_fh [format "%-14s%-14s%s" "Run Number" "Average" "Maximum"]
puts $out_fh [format "%-14s%-14s%s" "------------" "-------" "-------"]

# Iterate over each record in the sorted runs list and print the formatted row
foreach run $sorted_runs {
    set r_num   [lindex $run 0] ;# Extract run number
    set avg_val [lindex $run 1] ;# Extract raw average value
    set max_val [lindex $run 2] ;# Extract maximum integer found
    
    # Format the floating-point average to exactly 1 decimal point
    set formatted_avg [format "%.1f" $avg_val]
    
    # Write the row to the file 
    puts $out_fh [format "%-14s%-14s%s" $r_num $formatted_avg $max_val]
}

# Close the output file 
close $out_fh

# Print confirmation
puts "Successfully generated $outfile"
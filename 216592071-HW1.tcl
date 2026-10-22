# ==========================================
# HW1 - Part 1
# ==========================================

# 1. Setup Personal Variables
# The primary ID (branch representative) used for seeding and filename
set ID_NUMBER 216592071
# Format for header: Both names and IDs
set HEADER_NAMES "Dvir Museri 216687566, Amitay Ziv 216592071" 

# 2. Seed the random number generator using the representative's ID
expr { srand($ID_NUMBER) }

# ==========================================
# Calculate a running average
# ==========================================

# Open the output file for Part 1 (Write mode)
set filename1 "${ID_NUMBER}.part1"
set fh1 [open $filename1 w]

# Write the header EXACTLY as required by the assignment
puts $fh1 "# EX_1 $HEADER_NAMES"

# Randomize N (between 10 and 20 inclusive)
# int(rand()*11) returns 0..10. Adding 10 makes it 10..20
set N [expr { int(rand() * 11) + 10 }]
puts $fh1 "Number of runs: N = $N"

# Loop N times (Run Number starts from 1)
for {set i 1} {$i <= $N} {incr i} {
    puts $fh1 "Run Number: $i"
    puts $fh1 "-------------"
    
    # Randomize M (between 5 and 30 inclusive)
    # int(rand()*26) returns 0..25. Adding 5 makes it 5..30
    set M [expr { int(rand() * 26) + 5 }]
    puts $fh1 "M = $M"
    
    set sum 0
    
    # Loop M times to generate random numbers
    for {set j 0} {$j < $M} {incr j} {
        # Randomize a value between 0 and ID_NUMBER inclusive
        # We use $ID_NUMBER + 1 so the maximum possible value generated is exactly $ID_NUMBER
        set val [expr { int(rand() * ($ID_NUMBER + 1)) }]
        puts $fh1 $val
        
        # Add the value to the sum
        set sum [expr { $sum + $val }]
    }
    
    # Calculate average. Using double()to prevent integer division.
    set avg [expr { double($sum) / $M }]
    
    # Format the average to have exactly one decimal place (e.g., .0 or .5), 
    # to match the style of the assignment example.
    set formatted_avg [format "%.1f" $avg]
    puts $fh1 "Average = $formatted_avg"
    
    # Add an empty line between runs, EXCEPT after the very last run
    if {$i < $N} {
        puts $fh1 ""
    }
}

# Close the file 
close $fh1


# ==========================================
# PART 2: Parse and analyze the file
# ==========================================

# Open the .part1 file for reading (as required, we do not reuse memory variables)
set filename1 "${ID_NUMBER}.part1"
set fh1_read [open $filename1 r]

# Create an empty list to store the extracted data for each run
set run_data {}

# Initialize variables to keep track of the current run's data
set current_run 0
set current_max -1
set current_avg 0.0

# Read line by line until the end of the file
while { [gets $fh1_read line] >= 0 } {
    
    # Check if the line is "Run Number: X"
    # \d+ matches one or more digits. The parentheses ( ) capture those digits into 'current_run'
    if { [regexp {^Run Number:\s+(\d+)} $line match current_run] } {
        # New run started, reset the maximum value tracker
        set current_max -1
        
    } elseif { [regexp {^Average =\s+([\d\.]+)} $line match current_avg] } {
        # We reached the "Average = " line, which means this run's block is over.
        # We now have the run number, the max value, and the average.
        # Group them into a list and append it to our main 'run_data' list.
        lappend run_data [list $current_run $current_avg $current_max]
        
    } elseif { [regexp {^(\d+)$} $line match num] } {
        # This regex strictly matches a line containing ONLY digits (the random values).
        # It automatically ignores lines like "M = 15" or "-------------".
        # Check if the generated number is greater than the current maximum.
        if { $num > $current_max } {
            set current_max $num
        }
    }
}

# Close the reading file
close $fh1_read

# Sort the collected data by Average (ascending order)
# -real ensures numerical sorting (so 9.5 comes before 10.0)
# -index 1 tells Tcl to sort based on the 2nd element in our sublists (which is the average)
set sorted_data [lsort -real -index 1 $run_data]

# Open the output file for Part 2 (Write mode)
set filename2 "${ID_NUMBER}.part2"
set fh2 [open $filename2 w]

# Write the header EXACTLY as required by the assignment
puts $fh2 "# EX_1 $HEADER_NAMES"
puts $fh2 "Run Number    Average       Maximum"
puts $fh2 "------------  -------       -------"

# Loop through the sorted data and format the output
foreach run $sorted_data {
    # Extract the individual values from the sublist
    set run_id [lindex $run 0]
    set avg    [lindex $run 1]
    set max    [lindex $run 2]
    
    # Use the format command to align the columns exactly like the example:
    # %-14s takes the string and pads it with spaces on the right so it takes exactly 14 characters.
    set formatted_line [format "%-14s%-14s%s" $run_id $avg $max]
    puts $fh2 $formatted_line
}

# Close the file for Part 2
close $fh2

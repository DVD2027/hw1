# Student information
set id "345905673"
set student_name "Yonatan Chudnoff"

# Partner information
set partner_id "211469531"
set partner_name "Snir Offer"

# Initialize the random number generator
expr {srand($id)}

# Randomize N between 10 and 20
set N [expr {int(rand() * 11) + 10}]

# Open output file
set filename "${id}.part1"
set file [open $filename "w"]

# Write header
puts $file "# EX_1 $student_name $id $partner_name $partner_id"
puts $file "Number of runs: N = $N"

# Run N times
for {set i 1} {$i <= $N} {incr i} {

    if {$i > 1} {
        puts $file ""
    }

    puts $file "Run Number: $i"
    puts $file "-------------"

    # Randomize M between 5 and 30
    set M [expr {int(rand() * 26) + 5}]
    puts $file "M = $M"

    # Generate M random numbers
    set sum 0.0

    for {set j 0} {$j < $M} {incr j} {

        # Random integer between 0 and ID
        set num [expr {int(rand() * ($id + 1))}]

        puts $file $num

        set sum [expr {$sum + $num}]
    }

    # Calculate average
    set average [expr {$sum / $M}]
    puts $file [format "Average = %.1f" $average]
}

# Close the output file
close $file

puts "Results saved to $filename"



# ==========================================
# PART 2 - Parse and Analyze the File
# ==========================================

# Open the Part 1 file for reading
set input_filename "${id}.part1"
set input_file [open $input_filename "r"]

# Create a list to store the results
set results {}

# Read the file line by line
while {[gets $input_file line] >= 0} {

    # Check if the line contains a run number
    if {[regexp {^Run Number: ([0-9]+)} $line -> run_number]} {

        # Read the separator and M value
        gets $input_file line
        gets $input_file line

        # Extract M from the line
        scan $line "M = %d" M

        # Initialize the maximum
        set maximum 0

        # Read M random numbers
        for {set j 0} {$j < $M} {incr j} {

            gets $input_file line
            set num [string trim $line]

            # Find the maximum number
            if {$num > $maximum} {
                set maximum $num
            }
        }

        # Read the average line
        gets $input_file line

        # Extract the average
        scan $line "Average = %f" average

        # Store run number, average, and maximum
        lappend results [list $run_number $average $maximum]
    }
}

# Close the input file
close $input_file

# Sort results by average (ascending)
set results [lsort -real -index 1 $results]

# Create the Part 2 output file
set output_filename "${id}.part2"
set output_file [open $output_filename "w"]


# Write header
puts $output_file "# EX_1 $student_name $id $partner_name $partner_id"
puts $output_file [format "%-14s%-14s%s" "Run Number" "Average" "Maximum"]
puts $output_file [format "%-14s%-14s%s" "------------" "-------" "-------"]

# Write sorted results
foreach result $results {

    set run_number [lindex $result 0]
    set average [lindex $result 1]
    set maximum [lindex $result 2]

    puts $output_file [format "%-14s%-14.1f%s" $run_number $average $maximum]
}

# Close the output file
close $output_file

puts "Results saved to $output_filename"

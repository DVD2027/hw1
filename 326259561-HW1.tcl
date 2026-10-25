# Part 1: compute running average
# Helper procedures
proc rand_range {start end} {
    return [expr {$start + int(rand() * ($end - $start + 1))}]
}

proc average {numbers} {
    set sum 0
    foreach num $numbers {
        set sum [expr {$sum + $num}]
    }
    return [expr {double($sum) / [llength $numbers]}]
}

proc write_result {file_handle numbers run_num} {
    puts $file_handle "Run Number: $run_num\n-------------"
    puts $file_handle "M = [llength $numbers]" ;# Print value of M
    foreach num $numbers { ;# Print all numbers in the list
        puts $file_handle $num
    }
    set avg [average $numbers] ;# Compute the average of the given list of numbers
    puts $file_handle "Average = [format "%0.1f" $avg]"
}

# Set parameters/constants
set my_id 326259561
set N 15
expr {srand($my_id)}

set fh_1_w [open "$my_id.part1" w] ;# Create/open the file for part 1
puts $fh_1_w "# EX_1 Roei Groner $my_id, Eleonor Sahakian 318801529\nNumber of runs: N = $N"

# Run the loop
for {set i 1} {$i <= $N} {incr i} {
    set M [rand_range 5 30]
    set num_list [list] ;# Create an empty list, filled by the randomly generated numbers one by one
    for {set j 0} {$j < $M} {incr j} {lappend num_list [rand_range 0 $my_id]} ;# Create the M random numbers
    write_result $fh_1_w $num_list $i ;# Write the results to the relevant file
    if {$i != $N} {puts $fh_1_w ""} ;# Print new line before runs unless this is the final run
}

close $fh_1_w

# Part 2
# Read and analyze the file from part 1
set fh_1_r [open "$my_id.part1" r]
set max_num 0
set i 1
array set averages {} ;# Create empty array to store average:(run, max_num) pairs

while {[gets $fh_1_r line] >= 0} { ;# read line by line
    if {[regexp {^Average = (\d+\.\d+)$} $line match num]} { ;# Check if the current line contains the average
        set averages($num) [list $i $max_num]
        set max_num 0 ;# Reset max_num to 0 for next runs
        incr i ;# Increase the run number counter
    } elseif {[regexp {^\d+$} $line num]} { ;# Check if the current line contains just a single integer
        if {$num > $max_num} {set max_num $num}
    }
}

close $fh_1_r

# Sort averages array in ascending order (by the averages)
set sorted_avgs [lsort -real [array names averages]]

# Create/open the file for part 2, and write the header lines
set fh_2 [open "$my_id.part2" w]
puts $fh_2 "# EX_1 Roei Groner $my_id, Eleonor Sahakian 318801529"
puts $fh_2 [format "%-12s  %-12s  %-7s" "Run Number" "Average" "Maximum"]
puts $fh_2 "------------  -------       -------"

# Write the sorted values to the file
foreach avg $sorted_avgs {
    set run [lindex $averages($avg) 0]
    set max [lindex $averages($avg) 1]
    puts $fh_2 [format "%-12s  %-12s  %-7s" $run $avg $max]
}

close $fh_2
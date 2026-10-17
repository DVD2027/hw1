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

set fh_1 [open "$my_id.part1" w] ;# Create/open the file for part 1
puts $fh_1 "# EX_1 Roei Groner $my_id\nNumber of runs: N = $N"

# Run the loop
for {set i 1} {$i <= $N} {incr i} {
    set M [rand_range 5 30]
    set num_list [list] ;# Create an empty list, filled by the randomly generated numbers one by one
    for {set j 0} {$j < $M} {incr j} {lappend num_list [rand_range 0 $my_id]} ;# Create the M random numbers
    write_result $fh_1 $num_list $i ;# Write the results to the relevant file
    if {$i != $N} {puts $fh_1 ""} ;# Print new line before runs unless this is the final run
}

close $fh_1
# HW1 - Tcl Script for Digital VLSI Design
# Student ID: 209388115

# Initialize random seed based on student ID
expr { srand(209388115) }

# -----------------------------------------
# Part 1: Running average calculation
# -----------------------------------------
set part1_file "209388115.part1"
set f1 [open $part1_file w]

# Required header format
puts $f1 "# EX_1 Ori Naveh 209388115"

# Randomize N between 10 and 20
set N [expr {int(rand() * 11) + 10}]
puts $f1 "Number of runs: N = $N"

for {set i 1} {$i <= $N} {incr i} {
    puts $f1 "Run Number: $i"
    puts $f1 "----------"
    
    # Randomize M between 5 and 30
    set M [expr {int(rand() * 26) + 5}]
    puts $f1 "M = $M"
    
    set sum 0.0
    
    for {set j 0} {$j < $M} {incr j} {
        # Random value up to student ID
        set val [expr {int(rand() * 209388116)}]
        puts $f1 "$val"
        
        set sum [expr {$sum + $val}]
    }
    
    # Compute and format average
    set avg [expr {$sum / $M}]
    set avg_str [format "%.1f" $avg]
    puts $f1 "Average = $avg_str"
    puts $f1 ""
}

close $f1

# -----------------------------------------
# Part 2: Parse file and sort by average
# -----------------------------------------
# Read data strictly by parsing the .part1 file (No in-memory reuse)
set f_read [open $part1_file r]
set file_data [read $f_read]
close $f_read

set lines [split $file_data "\n"]

set parsed_runs {}
set current_run ""
set current_max -1
set current_avg ""
set numbers_collected {}

foreach line $lines {
    if {[string match "Run Number: *" $line]} {
        # If we were processing a previous run, save it before starting a new one
        if {$current_run ne ""} {
            lappend parsed_runs [list [expr {double($current_avg)}] $current_run $current_max]
        }
        set current_run [string range $line 12 end]
        set current_max -1
        set numbers_collected {}
    } elseif {[string match "M = *" $line]} {
        # Just metadata for M
    } elseif {[string match "Average = *" $line]} {
        set current_avg [string range $line 10 end]
    } elseif {[string match "----------" $line] || $line eq "" || [string match "# *" $line] || [string match "Number of runs: *" $line]} {
        # Skip headers and separators
    } else {
        # This is a random number generated in the run
        if {[string is integer -strict $line]} {
            if {$line > $current_max} {
                set current_max $line
            }
        }
    }
}

# Don't forget to append the last run
if {$current_run ne ""} {
    lappend parsed_runs [list [expr {double($current_avg)}] $current_run $current_max]
}

# Sort runs by average in ascending order
set sorted_runs [lsort -real -index 0 $parsed_runs]

# Write output to part2 file
set part2_file "209388115.part2"
set f2 [open $part2_file w]

puts $f2 "# EX_1 Ori Naveh 209388115"
puts $f2 "Run Number\tAverage\tMaximum"
puts $f2 "----------\t-------\t-------"

foreach item $sorted_runs {
    set avg_val [lindex $item 0]
    set run_num [lindex $item 1]
    set max_val [lindex $item 2]
    
    # Format average to 1 decimal place matching part1
    set avg_formatted [format "%.1f" $avg_val]
    puts $f2 "$run_num\t$avg_formatted\t$max_val"
}

close $f2
puts "Done! Part1 and Part2 generated successfully by parsing the file."
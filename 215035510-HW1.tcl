#!/usr/bin/env tclsh

# User Config
# Partners' names and Id's
set PARTNER1_NAME "Majd Abu Diab"
set PARTNER1_ID   "215035510"

set PARTNER2_NAME "Adi Asli"
set PARTNER2_ID   "327686754"

# The ID of the person uploading the assignment.
set MAIN_ID $PARTNER1_ID

# The exact text to print in the header of part1 and part2 files
set HEADER_LINE "# EX_1 $PARTNER1_NAME $PARTNER1_ID $PARTNER2_NAME $PARTNER2_ID"

set part1_file "${MAIN_ID}.part1"
set part2_file "${MAIN_ID}.part2"

# Use scan to parse ID as base-10 to avoid Tcl treating leading 0s as octal
scan $MAIN_ID "%d" numeric_id

# PART 1
# Seed the generator with the main ID
expr { srand($numeric_id) }

# N is in the range 10-20
set N [expr {int(rand() * 11) + 10}]

set f1 [open $part1_file w]
puts $f1 $HEADER_LINE
puts $f1 "Number of runs: N = $N"

for {set i 1} {$i <= $N} {incr i} {
    puts $f1 "Run Number: $i"
    puts $f1 "-------------"
    
    # M is in the range 5-30
    set M [expr {int(rand() * 26) + 5}]
    puts $f1 "M = $M"
    
    # Use 0.0 so Tcl defaults to float addition/division
    set sum 0.0 
    for {set j 0} {$j < $M} {incr j} {
        # Random values are in the range 0 to the MAIN_ID number
        set random_val [expr {int(rand() * ($numeric_id + 1))}]
        puts $f1 $random_val
        set sum [expr {$sum + $random_val}]
    }
    
    set avg [expr {$sum / $M}]
    
    # Write average formatted to 1 decimal place to match the example
    puts $f1 "Average = [format "%.1f" $avg]"
    puts $f1 "" ;# Empty line for formatting between runs
}
close $f1

# PART 2
# Read the Part 1 file (no in-memory values)
set f1_read [open $part1_file r]
set file_content [read $f1_read]
close $f1_read

set lines [split [string trim $file_content] "\n"]
set run_data {}

set current_run ""
set current_max -1
set current_avg ""

# State-machine parsing line by line
foreach line $lines {
    set line [string trim $line]
    
    if {[regexp {^Run Number:\s+(\d+)} $line -> run_num]} {
        set current_run $run_num
        set current_max -1
    } elseif {[regexp {^Average\s+=\s+([0-9.]+)} $line -> avg]} {
        set current_avg $avg
        lappend run_data [list $current_run $current_avg $current_max]
    } elseif {[regexp {^\d+$} $line val]} {
        # Identify the random generated digit rows to find maximum
        if {$val > $current_max} {
            set current_max $val
        }
    }
}

# Sort the extracted runs by the Average value (index 1 in the list) ascending
set sorted_runs [lsort -real -index 1 $run_data]

# Format and write to Part 2 file
set f2 [open $part2_file w]
puts $f2 $HEADER_LINE

# 14 spaces allocated for column 1 & 2. Trailing spaces string format for column 3.
puts $f2 [format "%-14s%-14s%s" "Run Number" "Average" "Maximum"]
puts $f2 [format "%-14s%-14s%s" "------------" "-------" "-------"]

foreach run $sorted_runs {
    set r_num [lindex $run 0]
    set r_avg [lindex $run 1]
    set r_max [lindex $run 2]
    
    puts $f2 [format "%-14s%-14s%s" $r_num $r_avg $r_max]
}
close $f2

puts "Successfully processed both parts. Check $part1_file and $part2_file."
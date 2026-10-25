#!/usr/bin/tclsh
# ==============================================================================
# HW1 - The Tool Command Language (Tcl)
# Course: 83-612 - Digital VLSI Design, Bar-Ilan University (2026-27)
# Student: Eitan Menasher (215068719)
# ==============================================================================

# 1. Seed the pseudo-random number generator with the student ID
expr { srand(215068719) }

set id "215068719"
set name "Eitan Menasher"
set N 10

set part1_filename "${id}.part1"
set part2_filename "${id}.part2"

# ==============================================================================
# Part 1: Generate random numbers, compute averages, and write to .part1
# ==============================================================================
set fh1 [open $part1_filename w]

puts $fh1 "# EX_1 $name $id"
puts $fh1 "Number of runs: N = $N"

for {set i 1} {$i <= $N} {incr i} {
    # M is in the range 5–30 -> int(rand() * 26) + 5 gives 5 to 30 inclusive
    set M [expr {int(rand() * 26) + 5}]
    
    puts $fh1 ""
    puts $fh1 "Run Number: $i"
    puts $fh1 "------------"
    puts $fh1 "M = $M"
    
    set sum 0.0
    set numbers [list]
    
    for {set j 0} {$j < $M} {incr j} {
        # Random value in range 0 to ID number (215068719)
        set val [expr {int(rand() * 215068720)}]
        lappend numbers $val
        set sum [expr {$sum + $val}]
        puts $fh1 $val
    }
    
    set avg [expr {$sum / $M}]
    # Format average to 1 decimal place matching example (e.g., 40117.5)
    puts $fh1 [format "Average = %.1f" $avg]
}

close $fh1

# ==============================================================================
# Part 2: Parse .part1, extract data, sort by average ascending, and write .part2
# ==============================================================================
set fh1 [open $part1_filename r]
set file_data [read $fh1]
close $fh1

set lines [split $file_data "\n"]

set runs_data [list]
set current_run ""
set current_m ""
set current_nums [list]
set parsing_numbers 0

foreach line $lines {
    set line [string trim $line]
    if {$line eq ""} { continue }
    
    if {[string match "Run Number: *" $line]} {
        set current_run [string range $line [string length "Run Number: "] end]
        set current_nums [list]
    } elseif {[string match "M = *" $line]} {
        set current_m [string range $line [string length "M = "] end]
        set parsing_numbers 1
    } elseif {[string match "Average = *" $line]} {
        set avg_val [string range $line [string length "Average = "] end]
        set parsing_numbers 0
        
        # Find maximum number in current run
        set max_val [lindex [lsort -integer -decreasing $current_nums] 0]
        
        # Store as a list: {run_num avg max}
        lappend runs_data [list $current_run $avg_val $max_val]
    } elseif {$parsing_numbers} {
        lappend current_nums [expr {$line + 0}]
    }
}

# Sort runs by average (ascending, numeric)
set sorted_runs [lsort -real -index 1 $runs_data]

set fh2 [open $part2_filename w]
puts $fh2 "# EX_1 $name $id"
puts $fh2 [format "%-14s%-13s %s" "Run Number" "Average" "Maximum"]
puts $fh2 "------------  -------       -------"

foreach r $sorted_runs {
    set rnum [lindex $r 0]
    set avg  [lindex $r 1]
    set maxv [lindex $r 2]
    puts $fh2 [format "%-14s%-13s %s" $rnum $avg $maxv]
}

close $fh2

puts "HW1 execution completed successfully. Generated $part1_filename and $part2_filename."

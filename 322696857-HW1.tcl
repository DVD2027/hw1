# HW1 Solution Script

# Student details
set ID "322696857"
set names "Aviv Holender 322696857 Yuval Segal 207486812"

# Convert ID to decimal to avoid octal interpretation issues
scan $ID %d numeric_ID

# ==========================================
# Part 1: Calculate a running average
# ==========================================
# Seed the random number generator
expr { srand($numeric_ID) }

# Randomize N between 10 and 20
set N [expr {int(rand()*11) + 10}]

set f1 [open "$ID.part1" w]
puts $f1 "# EX_1 $names"
puts $f1 "Number of runs: N = $N"

for {set i 1} {$i <= $N} {incr i} {
    puts $f1 "Run Number: $i"
    puts $f1 "-------------"
    
    # Randomize M between 5 and 30
    set M [expr {int(rand()*26) + 5}]
    puts $f1 "M = $M"
    
    set sum 0
    for {set j 1} {$j <= $M} {incr j} {
        # Random value between 0 and ID
        set val [expr {int(rand()*($numeric_ID+1))}]
        puts $f1 $val
        set sum [expr {$sum + $val}]
    }
    
    set avg [expr {double($sum) / $M}]
    puts $f1 "Average = $avg"
    
    # Add a blank line between runs (except the last one)
    if {$i < $N} {
        puts $f1 ""
    }
}
close $f1

# ==========================================
# Part 2: Parse and analyze the file
# ==========================================
set f1 [open "$ID.part1" r]
set file_content [read $f1]
close $f1
set lines [split $file_content "\n"]

set runs_data {}
set current_run ""
set current_max -1
set collecting 0

foreach line $lines {
    if {[regexp {^Run Number:\s*(\d+)} $line match run_num]} {
        set current_run $run_num
        set current_max -1
        set collecting 0
    } elseif {[regexp {^M = \d+} $line]} {
        set collecting 1
    } elseif {[regexp {^Average =\s*([\d\.]+)} $line match avg]} {
        lappend runs_data [list $current_run $avg $current_max]
        set collecting 0
    } elseif {$collecting && [regexp {^\s*(\d+)\s*$} $line match val]} {
        if {$val > $current_max} {
            set current_max $val
        }
    }
}

# Sort runs by average in ascending order
set sorted_runs [lsort -real -index 1 $runs_data]

set f2 [open "$ID.part2" w]
puts $f2 "# EX_1 $names"

# Print headers with left-aligned 14-character columns
puts $f2 [format "%-14s%-14s%s" "Run Number" "Average" "Maximum"]
puts $f2 [format "%-14s%-14s%s" "------------" "-------" "-------"]

foreach run_item $sorted_runs {
    set run_num [lindex $run_item 0]
    set avg [lindex $run_item 1]
    set max_val [lindex $run_item 2]
    
    # Print row data
    puts $f2 [format "%-14s%-14s%s" $run_num [format "%.1f" $avg] $max_val]
}
close $f2
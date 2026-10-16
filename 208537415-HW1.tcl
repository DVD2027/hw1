# Setup variables
set ID "208537415"
set header "# EX_1 Idan Itzhaki $ID"
set file1 "${ID}.part1"
set file2 "${ID}.part2"

# Seed the pseudo-random generator with your ID
expr { srand($ID) }

#  Calculate running averages

set fh1 [open $file1 w]
puts $fh1 $header

# N is in the range 10-20
set N [expr {int(rand()*11) + 10}]
puts $fh1 "Number of runs: N = $N"

for {set i 1} {$i <= $N} {incr i} {
    puts $fh1 "Run Number: $i"
    puts $fh1 "-------------"
    
    # M is in the range 5-30
    set M [expr {int(rand()*26) + 5}]
    puts $fh1 "M = $M"
    
    set sum 0.0
    for {set j 0} {$j < $M} {incr j} {
        # Random value in range 0 to ID
        set val [expr {int(rand() * ($ID + 1))}]
        puts $fh1 $val
        set sum [expr {$sum + $val}]
    }
    
    set avg [expr {$sum / double($M)}]
    puts $fh1 "Average = [format "%.1f" $avg]" 
    # single decimal precision (.lf)
    
    # Add an empty line between runs, but not after the very last run
    if {$i < $N} {
        puts $fh1 ""
    }
}
close $fh1



# Part 2: Parse and analyze the file

set fh1 [open $file1 r]
set runs_data {}

set current_run ""
set current_max -1

# Parse the part1 file line by line
while {[gets $fh1 line] >= 0} {
    set line [string trim $line]
    
    # Match run number
    if {[regexp {^Run Number:\s+(\d+)} $line match run_num]} {
        set current_run $run_num
        set current_max -1
        
    # Match standalone numbers (the M random values)
    } elseif {[regexp {^\d+$} $line]} {
        if {$current_max == -1 || $line > $current_max} {
            set current_max $line
        }
        
    # Match average
    } elseif {[regexp {^Average\s*=\s*([0-9\.]+)} $line match avg_val]} {
        # Store as a list: {run_number average maximum}
        lappend runs_data [list $current_run $avg_val $current_max]
    }
}
close $fh1

# Sort the data by average (index 1), ascending as a real number
set sorted_runs [lsort -real -index 1 $runs_data]

# Write to part2 formatted exactly like the example
set fh2 [open $file2 w]
puts $fh2 $header
puts $fh2 [format "%-14s%-14s%s" "Run Number" "Average" "Maximum"]
puts $fh2 [format "%-14s%-14s%s" "------------" "-------" "-------"]

foreach run_info $sorted_runs {
    set run_num [lindex $run_info 0]
    set avg     [lindex $run_info 1]
    set max     [lindex $run_info 2]
    
    puts $fh2 [format "%-14s%-14s%s" $run_num $avg $max]
}
close $fh2
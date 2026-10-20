set id "214951311" 
set id2 "323080028" 
set partner1 "Sigal Shedrinsky"
set partner2 "Noa Achrak" 

set filename "${id}.part1"
set out_file [open $filename w]

# Header line
puts $out_file "# EX_1 $partner1 $id and $partner2 $id2"

# Seed random gen with ID
expr { srand($id) }

# N runs between 10-20
set N [expr {int(rand() * 11) + 10}]
puts $out_file "Number of runs: N = $N"

for {set i 1} {$i <= $N} {incr i} {
    puts $out_file "Run Number: $i"
    puts $out_file "-------------"

    # M numbers between 5-30
    set M [expr {int(rand() * 26) + 5}]
    puts $out_file "M = $M"
    
    set sum 0.0 
    
    # Generate M values and sum them up
    for {set j 0} {$j < $M} {incr j} {
        set val [expr {int(rand() * ($id + 1))}]
        puts $out_file $val
        set sum [expr {$sum + $val}]
    }
    
    # Calc and print average (1 decimal point)
    set avg [expr {$sum / $M}]
    puts $out_file "Average = [format "%.1f" $avg]"
    
    puts $out_file ""
} 

close $out_file

# PART 2
# Open part1 for reading, part2 for writing
set in_file [open $filename r]
set out_filename "${id}.part2"
set out_file2 [open $out_filename w]

set runs_data {}
set current_run ""
set current_max -1
set current_avg ""

# Parse file line by line
while {[gets $in_file line] >= 0} {
    
    # Find run number
    if {[regexp {Run Number:\s+(\d+)} $line match run_num]} {
        set current_run $run_num
        set current_max -1

    # Find average and save run data to list    
    } elseif {[regexp {Average = ([\d.]+)} $line match avg_val]} {
        set current_avg $avg_val
        lappend runs_data [list $current_run $current_avg $current_max]

    # Find generated numbers to update max val    
    } elseif {[regexp {^(\d+)$} $line match val]} {
        if {$val > $current_max} {
            set current_max $val
        }
    }
}
close $in_file

# Sort list by average (index 1) ascending
set sorted_runs [lsort -real -index 1 $runs_data]

# Print table header
puts $out_file2 "# EX_1 $partner1 $id and $partner2 $id2"
puts $out_file2 [format "%-14s%-14s%s" "Run Number" "Average" "Maximum"]
puts $out_file2 [format "%-14s%-14s%s" "------------" "-------" "-------"]

# Print sorted table
foreach run_info $sorted_runs {
    set r [lindex $run_info 0]
    set a [lindex $run_info 1]
    set m [lindex $run_info 2]
    
    puts $out_file2 [format "%-14s%-14.1f%s" $r $a $m]
}
close $out_file2
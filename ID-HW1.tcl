set id "214951311" 
set id2 "323080028" 
set partner1 "Sigal Shedrinsky"
set partner2 "Noa Achrak" 

set filename "${id}.part1"
set out_file [open $filename w]

puts $out_file "# EX_1 $partner1 $id and $partner2 $id2"

expr { srand($id) }
set N [expr {int(rand() * 11) + 10}]
puts $out_file "Number of runs: N = $N"

for {set i 1} {$i <= $N} {incr i} {
    puts $out_file "Run Number: $i"
    puts $out_file "-------------"

    set M [expr {int(rand() * 26) + 5}]
    puts $out_file "M = $M"
    
    set sum 0.0 
    
    for {set j 0} {$j < $M} {incr j} {
        set val [expr {int(rand() * ($id + 1))}]
        puts $out_file $val
        set sum [expr {$sum + $val}]
    }
    
    set avg [expr {$sum / $M}]
    puts $out_file "Average = [format "%.1f" $avg]"
    
    puts $out_file ""
} 

close $out_file

set in_file [open $filename r]
set out_filename "${id}.part2"
set out_file2 [open $out_filename w]

set runs_data {}
set current_run ""
set current_max -1
set current_avg ""

while {[gets $in_file line] >= 0} {
    
    if {[regexp {Run Number:\s+(\d+)} $line match run_num]} {
        set current_run $run_num
        set current_max -1
        
    } elseif {[regexp {Average = ([\d.]+)} $line match avg_val]} {
        set current_avg $avg_val
        lappend runs_data [list $current_run $current_avg $current_max]
        
    } elseif {[regexp {^(\d+)$} $line match val]} {
        if {$val > $current_max} {
            set current_max $val
        }
    }
}
close $in_file
set sorted_runs [lsort -real -index 1 $runs_data]
puts $out_file2 "# EX_1 $partner1 $id and $partner2 $id2"
puts $out_file2 [format "%-14s%-14s%s" "Run Number" "Average" "Maximum"]
puts $out_file2 [format "%-14s%-14s%s" "------------" "-------" "-------"]
foreach run_info $sorted_runs {
    set r [lindex $run_info 0]
    set a [lindex $run_info 1]
    set m [lindex $run_info 2]
    
    puts $out_file2 [format "%-14s%-14.1f%s" $r $a $m]
}
close $out_file2
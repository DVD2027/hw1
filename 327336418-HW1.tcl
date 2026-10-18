set id_number 327336418 

expr {srand($id_number)}

set N [expr {10 + int(rand() * 11)}]

set filename "${id_number}.part1"
set fh [open $filename w]

puts $fh "# EX_1 Adina Lebovitz 327336418 Reut Kohanim 325351740"
puts $fh "Number of runs: N = $N"

for {set i 1} {$i <= $N} {incr i} {
      
    puts $fh "Run Number: $i"
    puts $fh "-------------"
    
    set M [expr {5 + int(rand() * 26)}]
    puts $fh "M = $M"
    
    set sum 0.0
   
    for {set j 0} {$j < $M} {incr j} {
        set val [expr {int(rand() * ($id_number + 1))}]
        puts $fh $val
        set sum [expr {$sum + $val}]
    }
    
    set avg [expr {$sum / $M}]
    puts $fh "Average = [format "%.1f" $avg]"
      
    if {$i < $N} {
        puts $fh ""
    }
}

close $fh



#part2:

set file2 "${id_number}.part2"

set fin [open $filename r]

set runs_data {}
set current_run ""
set current_max -1

while {[gets $fin line] >= 0} {
    set line [string trim $line]
    
    if {[regexp {^Run Number:\s(\d+)} $line match run_num]} {
        set current_run $run_num
        set current_max -1
        
    } elseif {[regexp {^Average\s*=\s*([0-9.]+)} $line match avg_val]} {
        lappend runs_data [list $current_run $avg_val $current_max]
        
    } elseif {[regexp {^(\d+)$} $line match num]} {
        if {$current_max == -1 || $num > $current_max} {
            set current_max $num
        }
    }
}
close $fin

set sorted_runs [lsort -real -index 1 $runs_data]

set fout [open $file2 w]

puts $fout "# EX_1 Adina Lebovitz 327336418 Reut Kohanim 325351740"
puts $fout "Run Number    Average       Maximum"
puts $fout "------------  -------       -------"

foreach run $sorted_runs {
    set run_num [lindex $run 0]
    set avg [lindex $run 1]
    set max [lindex $run 2]
    
    puts $fout [format "%-14s%-14s%s" $run_num $avg $max]
}

close $fout
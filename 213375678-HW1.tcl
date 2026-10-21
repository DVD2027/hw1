set my_id 213375678
set my_name "Michal Namdar"

expr { srand($my_id) }
set fh [open "${my_id}.part1" w]
puts $fh "# EX_1 Michal Namdar 213375678 loren shaul 211549514"

set N [expr { int(rand() * 11) + 10 }]
puts $fh "Number of runs: N = $N"


for { set i 1 } { $i <= $N } { incr i } {
    puts $fh "Run Number: $i"
    puts $fh "------------"
    
    set M [expr { int(rand() * 26) + 5 }]
    puts $fh "M = $M"
    
    set sum 0
    
    for { set j 0 } { $j < $M } { incr j } {
        set rand_val [expr { int(rand() * ($my_id + 1)) }]
        puts $fh $rand_val
        set sum [expr { $sum + $rand_val }]
    }
    
    set avg [expr { double($sum) / $M }]
    puts $fh "Average = [format "%.1f" $avg]"
    puts $fh ""
}

close $fh


# part2

set all_runs {}
set in_file [open "${my_id}.part1" r]

set current_run ""
set current_avg ""
set current_max -1
set reading_numbers 0

while { [gets $in_file line] >= 0 } {
    if { [regexp {^Run Number:\s+(\d+)} $line match run_num] } {
        set current_run $run_num
        set current_max -1
        set reading_numbers 0
        continue
    }
    
    if { [regexp {^M\s*=} $line] } {
        set reading_numbers 1
        continue
    }
    
    if { [regexp {^Average\s*=\s*(.+)} $line match avg_val] } {
        set current_avg $avg_val
        set reading_numbers 0
        lappend all_runs [list $current_run $current_avg $current_max]
        continue
    }
    
    if { $reading_numbers && [regexp {^\d+$} $line] } {
        if { $line > $current_max } {
            set current_max $line
        }
    }
}

close $in_file

set sorted_runs [lsort -real -increasing -index 1 $all_runs]

set out_file [open "${my_id}.part2" w]

puts $out_file "# EX_1 $my_name $my_id loren shaul 211549514"
puts $out_file [format "%-14s%-14s%-14s" "Run Number" "Average" "Maximum"]
puts $out_file [format "%-14s%-14s%-14s" "------------" "-------" "-------"]

foreach run_data $sorted_runs {
    set r_num [lindex $run_data 0]
    set r_avg [lindex $run_data 1]
    set r_max [lindex $run_data 2]
    
    puts $out_file [format "%-14s%-14s%-14s" $r_num $r_avg $r_max]
}

close $out_file
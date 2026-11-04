# EX_1 Shani Sharon 212432967


############
## part 1
############

set MY_ID 212432967
expr { srand($MY_ID) }
set N [expr {int(rand() * 11) + 10}]
set fh [open "$MY_ID.part1" w]

puts $fh "# EX_1 Shani Sharon $MY_ID"
puts $fh "Number of runs: N = $N"

puts "N: $N"
set i 1
while {$i <= $N} {
    set M [expr {int(rand() * 26) + 5}]
    set j 1
    puts $fh "Run Number: $i"
    puts $fh "-------------"
    puts $fh "M = $M"
    set sum 0

    while {$j <= $M} {
        set rand_val [expr {int(rand() * ($MY_ID + 1))}]
        puts $fh $rand_val
        set sum [expr {$sum + $rand_val}]
        incr j
    }

    set avg [expr {$sum / double($M)}]
    puts $fh [format "Average = %0.1f" $avg]
    puts $fh ""
    incr i
}

close $fh

############
## part 2
############

set fh_read [open "$MY_ID.part1" r]
set file_data [read $fh_read]
close $fh_read

set lines [split $file_data "\n"]

set runs_list {}
set current_run ""
set current_max 0

foreach line $lines {
    if {[regexp {^Run Number: (\d+)} $line match r_num]} {
        set current_run $r_num
        set current_max 0
    } elseif {[regexp {^(\d+)} $line match rand_val]} {
        if {$rand_val > $current_max} {
            set current_max $rand_val
        }
    } elseif {[regexp {^Average = ([\d\.]+)} $line match avg_val]} {
        lappend runs_list [list $current_run $avg_val $current_max]
    }
}

set sorted_runs [lsort -real -index 1 $runs_list]

set fh_out [open "$MY_ID.part2" w]

puts $fh_out "# EX_1 Shani Sharon $MY_ID"
puts $fh_out "Run Number    Average       Maximum"
puts $fh_out "------------  -------       -------"

foreach run $sorted_runs {
    set r_num [lindex $run 0]
    set avg   [lindex $run 1]
    set maxv  [lindex $run 2]
    puts $fh_out [format "%-13s %-13s %s" $r_num $avg $maxv]
}

close $fh_out

puts "HW1 Script worked successfully! now check .part1 and .part2 files."

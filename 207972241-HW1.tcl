set names {"Matan Cohen" "Matan Guedj"}
set ID {"207972241" "212401582"}

expr {srand([lindex $ID 0])}
set N [expr {int(rand() * 11) + 10}]
set int_lim [expr {[lindex $ID 0] + 1}]
set i 1

set fh1 [open "[lindex $ID 0].part1" w]

puts $fh1 "# EX_1 [lindex $names 0] [lindex $ID 0] [lindex $names 1] [lindex $ID 1]"
puts $fh1 "Number of runs: N = $N"

while {$i<=$N} {
    set M [expr {int(rand() * 26) + 5}]

    puts $fh1 "Run Number: $i"
    puts $fh1 "-------------"
    puts $fh1 "M = $M"
    set total 0
    set j 0
    while {$j<$M} {
        set a [expr {int(rand() * $int_lim)}]        
        puts $fh1 $a
        set total [expr {$total + $a}]
        incr j
    }
    set avg [format {%0.1f} [expr {double($total)/$M}]]
    puts $fh1 "Average = $avg"
    puts $fh1 ""
    incr i
    }
close $fh1


set fh2 [open "[lindex $ID 0].part2" w]

puts $fh2 "# EX_1 [lindex $names 0] [lindex $ID 0] [lindex $names 1] [lindex $ID 1]"
puts $fh2 "Run Number    Average       Maximum"
puts $fh2 "------------  -------       -------"

set fh3 [open "[lindex $ID 0].part1" r]
set current_run ""

while {[gets $fh3 line] >= 0} {
    if {[regexp {Run Number:\s+(\d+)} $line match run_num]} {
        set current_run $run_num
        set RunData($current_run,avg) "N/A"
        set RunData($current_run,max) -1
    }

    if {[regexp {^\s*(\d+)\s*$} $line match num]} {
        if {$current_run ne ""} {
            if {$num > $RunData($current_run,max)} {
                set RunData($current_run,max) $num
            }
        }
    }

    if {[regexp {Average\s+=\s+([\d\.]+)} $line match avg_val]} {
        if {$current_run ne ""} {
            set RunData($current_run,avg) $avg_val
        }
    }
}

close $fh3


set unsorted_list {}

foreach key [array names RunData *,avg] {
    set run [lindex [split $key ","] 0]
    
    set avg $RunData($run,avg)
    set max $RunData($run,max)
    
    lappend unsorted_list [list $run $avg $max]
}

set sorted_list [lsort -real -index 1 $unsorted_list]

foreach run_data $sorted_list {
    set run [lindex $run_data 0]
    set avg [lindex $run_data 1]
    set max [lindex $run_data 2]
    
    set formatted_line [format "%-14s%-14s%s" $run $avg $max]
    
    puts $fh2 $formatted_line
}

close $fh2
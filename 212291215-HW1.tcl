set id 212291215
expr {srand($id)}
set runs [expr {10 + int(rand() * 11)}]
set out [open "$id.part1" w]
puts $out "# EX_1 Rom Barak 212291215 Noam Malca 209020825"
puts $out "Number of runs: N = $runs"

for {set run 1} {$run <= $runs} {incr run} {
    puts $out "Run Number: $run"
    puts $out "-------------"

    set m [expr {5 + int(rand() * 26)}]
    puts $out "M = $m"
    set sum 0

    for {set i 0} {$i < $m} {incr i} {
        set value [expr {int(rand() * ($id + 1))}]
        puts $out $value
        incr sum $value
    }

    set average [expr {double($sum) / $m}]
    set average [format "%.1f" $average]
    puts $out "Average = $average"
    if {$run < $runs} {
    puts $out ""
}
}
close $out

set in [open "$id.part1" r]
set records {}
set current_run ""
set current_max ""

while {[gets $in line] >= 0} {
    if {[regexp {^Run Number: ([0-9]+)$} $line match current_run]} {
        set current_max ""
        continue
    }

    if {[regexp {^Average = (.+)$} $line match current_average]} {
        lappend records [list $current_run $current_average $current_max]
        set current_run ""
        continue
    }

    if {$current_run ne "" && [string is integer -strict $line]} {
        if {$current_max eq "" || $line > $current_max} {
            set current_max $line
        }
    }
}
close $in

set records [lsort -real -index 1 $records]

set out2 [open "$id.part2" w]
puts $out2 "# EX_1 Rom Barak 212291215 Noam Malca 209020825"
puts $out2 [format "%-14s%-14s%s" "Run Number" "Average" "Maximum"]
puts $out2 [format "%-14s%-14s%s" "------------" "-------" "-------"]

foreach record $records {
    set sorted_run [lindex $record 0]
    set sorted_average [lindex $record 1]
    set sorted_max [lindex $record 2]
    puts $out2 [format "%-14s%-14s%s" $sorted_run $sorted_average $sorted_max]
}
close $out2

set ID 322808718
expr {srand($ID)}

set N [expr {10 + int(rand() * 11)}]
set fh [open "322808718.part1" w]

puts $fh "# EX_1 Tomer Hengel 322808718 Noy Chorin 208583575"
puts $fh "Number of runs: N = $N"

for {set i 1} {$i <= $N} {incr i} {

    set M [expr {5 + int(rand() * 26)}]
    set numbers {}

    for {set j 0} {$j < $M} {incr j} {
        set value [expr {int(rand() * ($ID + 1))}]
        lappend numbers $value
    }

    set sum 0

    foreach num $numbers {
        set sum [expr {$sum + $num}]
    }

set avg [expr {double($sum) / $M}]

puts $fh "Run Number: $i"
puts $fh "-------------"
puts $fh "M = $M"

foreach num $numbers {
    puts $fh $num
}

puts $fh "Average = [format "%.1f" $avg]"

if {$i < $N} {
    puts $fh ""
}
}

close $fh

set in_fh [open "322808718.part1" r]

set runs {}
set current_run 0
set current_max -1

while {[gets $in_fh line] >= 0} {

    if {[regexp {^Run Number: ([0-9]+)$} $line match run_num]} {
        set current_run $run_num
        set current_max -1

    } elseif {[regexp {^[0-9]+$} $line]} {
        set value $line

        if {$value > $current_max} {
            set current_max $value
        }

    } elseif {[regexp {^Average = (.+)$} $line match avg_value]} {
        lappend runs [list $avg_value $current_run $current_max]
    }
}

close $in_fh

set runs [lsort -real -index 0 $runs]

set out_fh [open "322808718.part2" w]

puts $out_fh "# EX_1 Tomer Hengel 322808718 Noy Chorin 208583575"
puts $out_fh "Run Number    Average       Maximum"
puts $out_fh "------------  -------       -------"

foreach run_data $runs {

    set avg_value [lindex $run_data 0]
    set run_num   [lindex $run_data 1]
    set max_value [lindex $run_data 2]

    set avg_formatted [format "%.1f" $avg_value]

    puts $out_fh [format "%-14s%-14s%s" \
        $run_num $avg_formatted $max_value]
}

close $out_fh
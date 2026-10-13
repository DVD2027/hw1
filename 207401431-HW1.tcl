set id "207401431"
set header_name "Yehuda and Ofir"
set header_line "# EX_1 Yehuda 207401431 Ofir 206690975"

expr { srand($id) }
set n [expr { int(rand() * 11) + 10 }]

set f1 [open "${id}.part1" w]
puts $f1 $header_line
puts $f1 "Number of runs: N = $n"

for {set i 1} {$i <= $n} {incr i} {
    puts $f1 "Run Number: $i"
    puts $f1 "-------------"
    
    set m [expr { int(rand() * 26) + 5 }]
    puts $f1 "M = $m"
    
    set sum 0
    for {set j 0} {$j < $m} {incr j} {
        set val [expr { int(rand() * ($id + 1)) }]
        puts $f1 $val
        set sum [expr {$sum + $val}]
    }
    
    set avg [expr { double($sum) / $m }]
    puts $f1 "Average = [format "%.1f" $avg]"
    
    if {$i < $n} {
        puts $f1 ""
    }
}
close $f1

set f1 [open "${id}.part1" r]
set run_data ""

set curr_run ""
set curr_max -1

while {[gets $f1 line] >= 0} {
    if {[regexp {^Run Number:\s*(\d+)} $line match r]} {
        set curr_run $r
        set curr_max -1
    } elseif {[regexp {^Average\s*=\s*([0-9.]+)} $line match a]} {
        lappend run_data [list $curr_run $a $curr_max]
    } elseif {[regexp {^\d+$} $line]} {
        if {$line > $curr_max} {
            set curr_max $line
        }
    }
}
close $f1

set sorted_data [lsort -real -index 1 $run_data]

set f2 [open "${id}.part2" w]
puts $f2 $header_line
puts $f2 [format "%-14s%-14s%s" "Run Number" "Average" "Maximum"]
puts $f2 [format "%-14s%-14s%s" "------------" "-------" "-------"]

foreach item $sorted_data {
    set r [lindex $item 0]
    set a [format "%.1f" [lindex $item 1]]
    set m [lindex $item 2]
    puts $f2 [format "%-14s%-14s%s" $r $a $m]
}
close $f2

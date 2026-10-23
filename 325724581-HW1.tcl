set fh [open "325724581.part1" w]
puts $fh "# EX_1 Ron Tutian 325724581"
expr {srand(325724581)}
set N [expr { int(rand()*11) + 10}]
puts $fh "Number of runs: N = $N"
set i 0
while {$i < $N} {
if { $i > 0} { puts $fh "" }
    incr i
   puts $fh "Run Number: $i"
   puts $fh "-------------"
   set M [expr { int(rand()*26) + 5}]
   puts $fh "M = $M"
set list1 [list]
    set j 0
while {$j < $M} {
    incr j
lappend list1 [expr { int(rand() * 325724581) }]
}
foreach a $list1 { puts $fh $a }
set summ 0
foreach a $list1 { set summ [expr $summ + $a] }
puts $fh "Average = [format {%0.1f} [expr double($summ) /$M]]"
}
close $fh
set fh1 [open "325724581.part1" r]
set fh2 [open "325724581.part2" w]
puts $fh2 "# EX_1 Ron Tutian 325724581"
puts $fh2 "Run Number    Average       Maximum"
puts $fh2 "------------  -------       -------"
set all_runs [list]
set current_max -1
set current_run ""

while {[gets $fh1 line] >= 0} {
    if {[string match "Run Number:*" $line]} {
        set current_run [lindex $line 2]
        set current_max -1
    } elseif {[string match "Average =*" $line]} {
        set avg [lindex $line 2]
        lappend all_runs [list $current_run $avg $current_max]
    } elseif {[regexp {^[0-9]+$} $line]} {
        if {$line > $current_max} {
            set current_max $line
        }
    }
}
close $fh1
set sorted_runs [lsort -real -index 1 $all_runs]
foreach run $sorted_runs {
    set r_num [lindex $run 0]
    set avg [lindex $run 1]
    set max [lindex $run 2]
    puts $fh2 [format {%-14s%-14s%s} $r_num $avg $max]
}
close $fh2

# EX_1 Yoav Barel 214439606
#part 1
expr {srand(214439606)}
set fh [open "214439606.part1" w]
puts $fh "# EX_1 Yoav Barel 214439606"
set N [expr 10+int(rand()*11)]
puts $fh "Number of runs: N = $N"
for {set i 1} {$i <= $N} {incr i} {
    set sum 0
    set M [expr 5+int(rand()*26)]
    puts $fh "Run Number: $i\n-------------\nM = $M"
    for {set j 0} {$j < $M} {incr j} {
        set a [expr int(rand()*214439607)]
        set sum [expr $sum + $a]
        puts $fh "$a"
    }
    puts $fh "Average = [expr double($sum)/$M]\n"
}
close $fh

#part 2
set fh [open "214439606.part1" r]
set list_runs [list]
set number_section 0
set current_max -1
set current_run 0
while {[gets $fh line] >= 0} {
    set line [string trim $line]
    if {$line eq ""} {
        continue
    }
    if {[string match "Run Number:*" $line]} {
        scan $line "Run Number: %d" current_run
        set current_max -1
        set number_section 0
    } elseif {[string match "M =*" $line]} {
        set number_section 1
    } elseif {[string match "Average =*" $line]} {
        set number_section 0
        scan $line "Average = %f" current_avg
        lappend list_runs [list $current_run $current_avg $current_max]
    } elseif {$number_section} {
        if {$current_max == -1 || $line > $current_max} {
            set current_max $line
        }
    }
}
close $fh
set sorted_runs [lsort -real -index 1 $list_runs]
set out [open "214439606.part2" w]
puts $out "# EX_1 Yoav Barel 214439606"
puts $out [format "%-14s%-14s%s" "Run Number" "Average" "Maximum"]
puts $out [format "%-14s%-14s%s" "------------" "-------" "-------"]
foreach item $sorted_runs {
    puts $out [format "%-14s%-14.1f%s" [lindex $item 0] [lindex $item 1] [lindex $item 2]]
}

close $out
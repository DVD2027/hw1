set my_id 215627332
set header "# EX_1 David Kosukhkin $my_id Idan Dinovitch 215400912"
set part1_file "${my_id}.part1"
set part2_file "${my_id}.part2"

# Seed once, before generating any numbers.
expr {srand($my_id)}

# Part 1
set N [expr {10 + int(rand() * 11)}]

set f1 [open $part1_file w]
puts $f1 $header
puts $f1 "Number of runs: N = $N"

for {set i 1} {$i <= $N} {incr i} {
    set M [expr {5 + int(rand() * 26)}]
    set sum 0.0
    set nums {}

    for {set j 0} {$j < $M} {incr j} {
        set val [expr {int(rand() * ($my_id + 1))}]
        lappend nums $val
        set sum [expr {$sum + $val}]
    }
    # sum is a double, so the division keeps the fractional part.
    set avg [expr {$sum / $M}]

    puts $f1 "Run Number: $i"
    puts $f1 "-------------"
    puts $f1 "M = $M"

    foreach val $nums {
        puts $f1 $val
    }

    puts $f1 [format "Average = %.1f" $avg]
    puts $f1 ""
}

close $f1

# Part 2: get the run data from the file.
set f1 [open $part1_file r]
set runs {}

gets $f1 saved_header

while {[gets $f1 line] >= 0} {
    if {[string match "Run Number: *" $line]} {
        set cur_run [lindex $line 2]
        set cur_nums {}

    } elseif {[string is integer -strict $line]} {
        lappend cur_nums $line

    } elseif {[string match "Average = *" $line]} {
        set avg_val [lindex $line 2]

        set max_val [lindex $cur_nums 0]
        foreach n $cur_nums {
            if {$n > $max_val} {
                set max_val $n
            }
        }

        # Keep each run's details together.
        lappend runs [list $cur_run $avg_val $max_val]
    }
}
close $f1

# Average is the second element of each record.
set runs [lsort -real -increasing -index 1 $runs]
set f2 [open $part2_file w]
puts $f2 $saved_header
puts $f2 "Run Number    Average       Maximum"
puts $f2 "------------  -------       -------"

foreach item $runs {
    set r_num [lindex $item 0]
    set r_avg [lindex $item 1]
    set r_max [lindex $item 2]

    puts $f2 [format "%-14d%-14.1f%d" $r_num $r_avg $r_max]
}

puts $f2 ""
close $f2

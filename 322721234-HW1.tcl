# HW1 - Part 1

set student_id 322721234

expr {srand($student_id)}

set N [expr {int(rand() * 11) + 10}]

set fh [open "${student_id}.part1" w]

puts $fh "# EX_1 Ofir Aharony 322721234 Shahar Admoni 206591463"

puts $fh "Number of runs: N = $N"

for {set i 1} {$i <= $N} {incr i} {

set M [expr {int(rand()*26)+5}]

set sum 0

puts $fh "Run Number: $i"

puts $fh "-------------"

puts $fh "M = $M"

for {set j 0} {$j < $M} {incr j} {

set num [expr {int(rand() * ($student_id + 1))}]

puts $fh $num

set sum [expr {$sum + $num}]

}

set avg [expr {double($sum) / $M}]

puts $fh "Average = [format "%.1f" $avg]"

if {$i < $N} {
    puts $fh ""
}

}

close $fh

# HW1 - Part 2

set in_fh [open "${student_id}.part1" r]

set runs {}

set current_run 0

set max_num 0

while {[gets $in_fh line] >= 0} {

    if {[regexp {^Run Number: ([0-9]+)$} $line match run_number]} {

        set current_run $run_number
        set max_num 0

    } elseif {[regexp {^Average = ([0-9.]+)$} $line match avg]} {

        lappend runs [list $current_run $avg $max_num]

    } elseif {[string is integer -strict $line]} {

        if {$line > $max_num} {
            set max_num $line
        }
    }
}

close $in_fh

set sorted_runs [lsort -real -index 1 $runs]

set out_fh [open "${student_id}.part2" w]

puts $out_fh "# EX_1 Ofir Aharony 322721234 Shahar Admoni 206591463"

puts $out_fh [format "%-14s%-14s%s" "Run Number" "Average" "Maximum"]

puts $out_fh [format "%-14s%-14s%s" "------------" "-------" "-------"]

foreach run $sorted_runs {

    lassign $run run_number avg max_num

    puts $out_fh [format "%-14s%-14s%s" $run_number $avg $max_num]
}

close $out_fh

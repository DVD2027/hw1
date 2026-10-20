# HW1 - Tcl file generation and analysis

set id 212328611
set partner_id 326682333
set header "# EX_1 Maayan Jackson $id Hadar Harmatz $partner_id"
set runs 12

# Reproducible random sequence
expr {srand($id)}

# Part 1: Generate random numbers and averages

set out [open "${id}.part1" w]
puts $out $header
puts $out "Number of runs: N = $runs"

for {set run 1} {$run <= $runs} {incr run} {
    set count [expr {5 + int(rand() * 26)}]
    set total 0

    puts $out "Run Number: $run"
    puts $out "-------------"
    puts $out "M = $count"

    for {set j 0} {$j < $count} {incr j} {
        set value [expr {int(rand() * ($id + 1))}]
        puts $out $value
        set total [expr {$total + $value}]
    }

    set average [expr {double($total) / $count}]
    puts $out "Average = [format %.1f $average]"
    puts $out ""
}
close $out

# Part 2: Read and analyze Part 1

set in [open "${id}.part1" r]
set records {}
set run_number ""
set largest -1

while {[gets $in line] != -1} {

    if {[regexp {^Run Number: ([0-9]+)$} $line whole number]} {
        set run_number $number
        set largest -1

    } elseif {[regexp {^[0-9]+$} $line]} {
        if {$line > $largest} {
            set largest $line
        }

    } elseif {[regexp {^Average = ([0-9]+(?:\.[0-9]+)?)$} $line whole average]} {
        lappend records [list $run_number $average $largest]
    }
}

close $in

# Sort runs by average in ascending order

set records [lsort -real -index 1 $records]

# Write the sorted summary to Part 2

set out [open "${id}.part2" w]
puts $out $header
puts $out "Run Number    Average       Maximum"
puts $out "------------  -------       -------"

foreach record $records {
    lassign $record number average largest
    puts $out [format "%-14s%-14s%s" $number $average $largest]
}

close $out

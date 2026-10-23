
# ============================================================
# PART 1 - Calculate a running average
# ============================================================

set ID 315836668
set first_name "Nitzan"
set last_name "Rozen"

set ID2 209351386
set first_name2 "Moshe"
set last_name2 "Levi"

expr {srand($ID)}

set N [expr {int(rand()*11) + 10}]

set out [open "${ID}.part1" w]

puts $out "# EX_1 $first_name $last_name $ID & $first_name2 $last_name2 $ID2"
puts $out "Number of runs: N = $N"

for {set i 1} {$i <= $N} {incr i} {

    puts $out ""
    puts $out "Run Number: $i"
    puts $out "-------------"
    puts $out ""

    set M [expr {int(rand()*26) + 5}]

    puts $out "M = $M"

    set sum 0

    for {set j 0} {$j < $M} {incr j} {

        set value [expr {int(rand()*($ID + 1))}]

        puts $out $value

        set sum [expr {$sum + $value}]
    }

    set average [expr {double($sum) / $M}]

    puts $out [format "Average = %.1f" $average]
}

close $out


# ============================================================
# PART 2 - Parse and analyze the Part 1 file
# ============================================================

set in [open "${ID}.part1" r]

set runs {}

set reading_values 0

while {[gets $in line] >= 0} {

    if {[string match "# EX_1 *" $line]} {
        set header_line $line
    }

    if {[regexp {^Run Number: ([0-9]+)$} $line match run_number]} {

        set reading_values 0
        set maximum 0
    }

    if {[regexp {^M = ([0-9]+)$} $line match M_from_file]} {

        set reading_values 1
    }

    if {$reading_values} {

        if {[regexp {^[0-9]+$} $line]} {

            set value_from_file $line

            if {$value_from_file > $maximum} {
                set maximum $value_from_file
            }
        }
    }

    if {[regexp {^Average = ([0-9]+\.[0-9]+)$} $line match average_from_file]} {

        set reading_values 0

        lappend runs [list $average_from_file $run_number $maximum]
    }
}

close $in


# Sort by average, ascending
set sorted_runs [lsort -real -index 0 $runs]


# Create Part 2 output file
set out2 [open "${ID}.part2" w]

puts $out2 $header_line
puts $out2 [format "%-14s%-13s%s" "Run Number" "Average" "Maximum"]
puts $out2 [format "%-14s%-13s%s" "----------" "-------" "-------"]

foreach run $sorted_runs {

    set average_from_file [lindex $run 0]
    set run_number        [lindex $run 1]
    set maximum           [lindex $run 2]

    puts $out2 [format "%-14s%-13s%s"  $run_number $average_from_file $maximum]
}

close $out2


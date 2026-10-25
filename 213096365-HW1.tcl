# HW1 - Digital VLSI Design
# Matan Yakobovich 213096365, Uriel Cohen 314831298

set id     213096365
set header "# EX_1 Matan Yakobovich 213096365 Uriel Cohen 314831298"

# Seed the random generator with my ID
expr { srand($id) }

# ==========================================================
# Part 1: Calculate a running average
# ==========================================================

set out [open "$id.part1" w]
fconfigure $out -translation lf   ;# Linux line endings

# N is a random number between 10 and 20
set N [expr { 10 + int(rand() * 11) }]

puts $out $header
puts $out "Number of runs: N = $N"

for { set run 1 } { $run <= $N } { incr run } {

    # M is a random number between 5 and 30
    set M [expr { 5 + int(rand() * 26) }]

    puts $out "Run Number: $run"
    puts $out "-------------"
    puts $out "M = $M"

    # Generate M random values between 0 and my ID and sum them
    set sum 0
    for { set i 0 } { $i < $M } { incr i } {
        set value [expr { int(rand() * ($id + 1)) }]
        puts $out $value
        set sum [expr { $sum + $value }]
    }

    set average [expr { double($sum) / $M }]
    puts $out "Average = $average"

    # Empty line between runs (not after the last one)
    if { $run < $N } {
        puts $out ""
    }
}

close $out

# ==========================================================
# Part 2: Parse and analyze the file
# ==========================================================

# Read the .part1 file line by line and collect, for every run,
# its number, its average and its maximum value
set in [open "$id.part1" r]

set runs {}
while { [gets $in line] >= 0 } {

    if { [regexp {^Run Number: (\d+)} $line match number] } {
        # A new run starts
        set run_number $number
        set max -1

    } elseif { [regexp {^(\d+)$} $line match value] } {
        # A random value - keep the largest one
        if { $value > $max } {
            set max $value
        }

    } elseif { [regexp {^Average = (.+)$} $line match avg] } {
        # End of the run - save {run average maximum}
        lappend runs [list $run_number $avg $max]
    }
}

close $in

# Sort the runs by average (index 1), smallest first
set sorted_runs [lsort -real -increasing -index 1 $runs]

# Write the .part2 file
set out [open "$id.part2" w]
fconfigure $out -translation lf   ;# Linux line endings

puts $out $header
puts $out [format "%-12s  %-12s  %s" "Run Number" "Average" "Maximum"]
puts $out [format "%-12s  %-12s  %s" "------------" "-------" "-------"]

foreach item $sorted_runs {
    set run_number [lindex $item 0]
    set avg        [lindex $item 1]
    set max        [lindex $item 2]
    puts $out [format "%-12s  %-12s  %s" $run_number $avg $max]
}

close $out

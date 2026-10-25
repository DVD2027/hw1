
# HW1 - DVD
# Michelle Tobias - 342727443
# Yam Band - 322806605

set student_id 342727443
set header "# EX_1 Michelle Tobias 342727443 Yam Band 322806605"

# Initialize the random number generator
expr {srand($student_id)}

# PART 1 - Generate random numbers

# Generate N between 10 and 20
set N [expr {int(rand() * 11) + 10}]

# Open the first output file
set part1 "${student_id}.part1"
set out [open $part1 w]

puts $out $header
puts $out "Number of runs: N = $N"

# Repeat N times
for {set run 1} {$run <= $N} {incr run} {

    # Generate M between 5 and 30
    set M [expr {int(rand() * 26) + 5}]

    puts $out "Run Number: $run"
    puts $out "-------------"
    puts $out "M = $M"

    set sum 0

    # Generate M random numbers
    for {set j 0} {$j < $M} {incr j} {

        set number [expr {int(rand() * ($student_id + 1))}]

        puts $out $number

        # Add number to sum
        set sum [expr {$sum + $number}]
    }

    # Calculate average
    set average [expr {double($sum) / $M}]

    puts $out "Average = $average"
    puts $out ""
}

close $out

# PART 2 - Parse and analyze Part 1

# Open Part 1 file for reading
set in [open $part1 r]

set runs {}
set current_run 0
set maximum 0

# Read file line by line
while {[gets $in line] >= 0} {

    # Find run number
    if {[regexp {^Run Number: ([0-9]+)$} $line -> run_number]} {

        set current_run $run_number
        set maximum 0

    # Find random numbers
    } elseif {[regexp {^([0-9]+)$} $line -> number]} {

        if {$number > $maximum} {
            set maximum $number
        }

    # Find average
    } elseif {[regexp {^Average = (.+)$} $line -> average]} {

        lappend runs [list $current_run $average $maximum]
    }
}

close $in

# Sort runs by average

proc compare_averages {a b} {

    set avg1 [lindex $a 1]
    set avg2 [lindex $b 1]

    if {$avg1 < $avg2} {
        return -1
    }

    if {$avg1 > $avg2} {
        return 1
    }

    return 0
}

set sorted_runs [lsort -command compare_averages $runs]

# Write Part 2 output

set part2 "${student_id}.part2"
set out [open $part2 w]

puts $out $header
puts $out "Run Number    Average       Maximum"
puts $out "------------  -------       -------"

foreach entry $sorted_runs {

    lassign $entry run_number average maximum

    puts $out [format "%-14s%-14s%s" $run_number $average $maximum]
}

close $out

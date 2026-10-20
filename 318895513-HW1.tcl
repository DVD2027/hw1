
# Part 1: Generate random numbers

expr {srand(318895513)}

set N [expr {int(rand()*11) + 10}]
set fh [open "318895513.part1" w]

puts $fh "# EX_1 Asaf Ben Haim 318895513 Avior Neveem 322409905"
puts $fh "Number of runs: N = $N"

# Repeat N times
for {set i 1} {$i <= $N} {incr i} {
    set M [expr {int(rand()*26) + 5}]

    puts $fh "Run Number: $i"
    puts $fh "-------------"
    puts $fh "M = $M"

    set sum 0

    # Generate M numbers and calculate their sum
    for {set j 1} {$j <= $M} {incr j} {
        set num [expr {int(rand()*(318895513 + 1))}]
        puts $fh $num
        set sum [expr {$sum + $num}]
    }

    # Calculate and print the average
    set average [expr {double($sum) / $M}]
    puts $fh "Average = [format "%.1f" $average]"

    if {$i < $N} {
        puts $fh ""
    }
}

close $fh


# Part 2: Read and sort the results

set fh [open "318895513.part1" r]
set results {}
set run_number 0
set maximum 0

# Read the file line by line
while {[gets $fh line] >= 0} {

    # Find the run number
    if {[regexp {^Run Number: ([0-9]+)$} $line match number]} {
        set run_number $number
        set maximum 0

    # Find the maximum number in each run
    } elseif {[regexp {^([0-9]+)$} $line match num]} {
        if {$num > $maximum} {
            set maximum $num
        }

    # Save the run results
    } elseif {[regexp {^Average = ([0-9.]+)$} $line match average]} {
        lappend results [list $run_number $average $maximum]
    }
}

close $fh

# Sort runs by average (ascending)
set sorted_results [lsort -real -index 1 $results]

set fh [open "318895513.part2" w]

puts $fh "# EX_1 Asaf Ben Haim 318895513 Avior Neveem 322409905"
puts $fh "Run Number    Average       Maximum"
puts $fh "------------  -------       -------"

# Write the sorted results
foreach result $sorted_results {
    set run_number [lindex $result 0]
    set average [lindex $result 1]
    set maximum [lindex $result 2]

    puts $fh [format "%-14s%-14s%s" $run_number $average $maximum]
}

close $fh

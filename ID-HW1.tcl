# Representative's ID: replace with the actual 9-digit ID
set id "212849103"

# Convert the ID to a decimal number, including IDs with leading zeros
scan $id %d id_number

# Initialize the random-number generator
expr {srand($id_number)}

# Randomize the number of runs: 10 to 20
set N [expr {10 + int(rand() * 11)}]

puts "Number of runs: N = $N"

# Open the output file for writing
set out [open "${id}.part1" w]

# Header: replace with both partners' actual names and IDs
puts $out "# EX_1 Rivka Maman $id Elad Toledano 212105852"
puts $out "Number of runs: N = $N"

# Perform N runs
for {set run 1} {$run <= $N} {incr run} {
    set M [expr {5 + int(rand() * 26)}]
    set sum 0

    puts $out "Run Number: $run"
    puts $out "-------------"
    puts $out "M = $M"

    # Generate M integers and calculate their sum
    for {set j 0} {$j < $M} {incr j} {
        set value [expr {int(rand() * ($id_number + 1))}]
        puts $out $value
        set sum [expr {$sum + $value}]
    }

    set average [expr {double($sum) / $M}]
    puts $out "Average = $average"
    puts $out ""
}

close $out

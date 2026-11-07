
# HW1 - Part 1

# Representative's ID
set student_id 207063744

# Student information
set student_name "Kreem Hussein"

# Seed random generator
expr {srand($student_id)}

# Choose N between 10 and 20
set N [expr {int(rand() * 11) + 10}]

# Open output file
set file [open "$student_id.part1" w]

# Write header
puts $file "# EX_1 $student_name $student_id"
puts $file "Number of runs: N = $N"

# Generate N runs
for {set i 1} {$i <= $N} {incr i} {

    set M [expr {int(rand() * 26) + 5}]
    set sum 0

    puts $file "Run Number: $i"
    puts $file "-------------"
    puts $file "M = $M"

    for {set j 0} {$j < $M} {incr j} {

        set number [expr {int(rand() * ($student_id + 1))}]

        puts $file $number
        set sum [expr {$sum + $number}]
    }

    set average [expr {double($sum) / $M}]

    puts $file "Average = $average"
    puts $file ""
}

close $file

puts "Part 1 completed!"



# HW1 - Part 2

# Open Part 1 file for reading
set input [open "$student_id.part1" r]

set results {}
set run_number 0
set maximum 0

# Read file line by line
while {[gets $input line] >= 0} {

    # Find run number
    if {[regexp {^Run Number: ([0-9]+)} $line match num]} {
        set run_number $num
        set maximum 0
    }

    # Find random numbers
    if {[regexp {^[0-9]+$} $line]} {
        if {$line > $maximum} {
            set maximum $line
        }
    }

    # Find average
    if {[regexp {^Average = (.+)$} $line match avg]} {
        lappend results [list $run_number $avg $maximum]
    }
}

close $input

# Sort by average (ascending)
set results [lsort -real -index 1 $results]

# Create Part 2 output file
set output [open "$student_id.part2" w]

puts $output "# EX_1 $student_name $student_id"
puts $output "Run Number    Average       Maximum"
puts $output "------------  -------       -------"

foreach result $results {
    set run [lindex $result 0]
    set avg [lindex $result 1]
    set max [lindex $result 2]

    puts $output [format "%-14s  %-20s  %s" $run $avg $max]
}

close $output

puts "Part 2 completed!"

# Student information
set representative_name "Arad Saad"
set representative_id "314633264"
set second_name "Ori Moyal"
set second_id "316261684"

# Initialize random generator
scan $representative_id %d seed
expr {srand($seed)}

# Number of runs
set N 10

set output_file "${representative_id}.part1"

set fh [open $output_file w]

puts $fh "# EX_1 $representative_name $representative_id $second_name $second_id"
puts $fh "Number of runs: N = $N"

for {set run 1} {$run <= $N} {incr run} {

    # Generate random M between 5 and 30
    set M [expr {5 + int(rand() * 26)}]

    puts $fh "Run Number: $run"
    puts $fh "-------------"
    puts $fh "M = $M"

    set sum 0

    for {set i 0} {$i < $M} {incr i} {

        # Generate random integer between 0 and ID
        set value [expr {int(rand() * ($seed + 1))}]

        puts $fh $value

        set sum [expr {$sum + $value}]
    }

    # Calculate average
    set average [expr {double($sum) / $M}]

    puts $fh "Average = [format %.1f $average]"

    if {$run < $N} {
        puts $fh ""
    }
}

close $fh

puts "Created $output_file"


# Part 2 - Parse and analyze Part 1 output

# Open Part 1 file for reading
set input_fh [open $output_file r]

set run_data {}
set run_number ""
set maximum -1

# Read the file line by line
while {[gets $input_fh line] >= 0} {

    # Identify the run number
    if {[regexp {^Run Number: ([0-9]+)$} $line -> num]} {
        set run_number $num
        set maximum -1

    # Identify a random number and update the maximum
    } elseif {[regexp {^[0-9]+$} $line]} {
        if {$line > $maximum} {
            set maximum $line
        }

    # Identify the average and save the run data
    } elseif {[regexp {^Average = ([0-9]+\.[0-9]+)$} $line -> average]} {
        lappend run_data [list $run_number $average $maximum]
    }
}

close $input_fh

# Sort runs by average in ascending order
set run_data [lsort -real -index 1 $run_data]

# Create Part 2 output file
set output_file2 "${representative_id}.part2"
set output_fh [open $output_file2 w]

# Write header
puts $output_fh "# EX_1 $representative_name $representative_id $second_name $second_id"

puts $output_fh [format "%-14s%-14s%s" "Run Number" "Average" "Maximum"]
puts $output_fh [format "%-14s%-14s%s" "------------" "-------" "-------"]

# Write sorted results
foreach row $run_data {
    lassign $row run_number average maximum
    puts $output_fh [format "%-14s%-14s%s" $run_number $average $maximum]
}

close $output_fh

puts "Created $output_file2"

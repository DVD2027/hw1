# HW1 - Part B.1

set id 212201172

# Initialize random generator
expr {srand($id)}

# Generate N between 10 and 20

# The general formula for generating a random int between min and max:
# set X [expr {int(rand() * (MAX - MIN + 1)) + MIN}]
set N [expr {int(rand() * 11) + 10}]

#Open output file
set filename "${id}.part1" ; # Store the filename
set fh [open $filename w]  ; # Create/open the file

# Write header
puts $fh "# EX_1 Lia Iska Bezalel 212201172"
puts $fh "Number of runs: N = $N"

# Outer loop- run the loop N times
for {set i 1} {$i <= $N} {incr i} {

    # Generate M between 5 and 30
    set M [expr {int(rand() * 26) + 5}]

    puts $fh "Run Number: $i"
    puts $fh "-------------"
    puts $fh "M = $M"
    
    set sum 0

# Inner loop- generate M random numbers
    for {set j 0} {$j < $M} {incr j} {

        set number [expr {int(rand() * ($id + 1))}]

        puts $fh $number
	set sum [expr {$sum + $number }]
    }
    set average [expr { double($sum) / $M }]
    puts $fh [format "Average = %.1f" $average]

    # Blank line between runs
    if {$i < $N} {
        puts $fh ""
    }
}

# Close output file
close $fh

# Part B.2 - Read the output file

set fh [open $filename r]

set results {}

# ^ = start, [0-9]+ = one or more digits, () = capture digits, $ = end
# match = full matched text, run_number = extracted number

while {[gets $fh line] >= 0} {

    # Extract run number
    if {[regexp {^Run Number: ([0-9]+)$} $line match run_number]} {
   set maximum -1     
 }

# Identify lines containing only an integer
if {[regexp {^[0-9]+$} $line]} {
    if {$line > $maximum} {
        set maximum $line
    }
}

    # Extract average and display maximum

    if {[regexp {^Average = (.+)$} $line match average]} { 
	lappend results [list $average $run_number $maximum]
    }
}

close $fh

# Sort the runs by average (index 0) in ascending numerical order (-real)
# set sorted_results [lsort -real -index 0 $results]
set sorted_results [lsort -real -index 0 $results]

# Part B.2 - Write sorted results to output file

set fh [open "${id}.part2" w]

# Write header
puts $fh "# EX_1 Lia Iska Bezalel 212201172"
puts $fh "Run Number    Average       Maximum"
puts $fh "------------  -------       -------"

# Write sorted results
foreach run $sorted_results {

    set run_number [lindex $run 1]
    set average [lindex $run 0]
    set maximum [lindex $run 2]
	# Write a formatted row: left-align run number and average (min. 14 chars each), then maximum
	#puts $fh [format "%-14s%-14s%s" $run_number $average $maximum]
    puts $fh [format "%-14s%-14s%s" $run_number $average $maximum]
}

close $fh


#HW1- Digital VLSI Design
#EX_1 - Rotem Golov 207704149 & Orel Cohen 318733219

set my_id 207704149

# Open the first output file
set file_id [open "207704149.part1" w]

# Writes the header
puts $file_id "# EX_1 Rotem Golov $my_id & Orel Cohen 318733219"

# Initialize random number generation
expr { srand($my_id) }

# Generate the number of runs in range (10-20)
set N [expr { int(rand() * 11) + 10 }]

# Write the total number of runs
puts $file_id "Number of runs: N = $N "

# Creating the loop for N
for {set i 1} {$i <= $N} {incr i} {
    puts $file_id "Run Number: $i"
    puts $file_id "--------------"
    
    # Generate M in in range (5-30)
    set M [expr { int(rand() * 26) + 5}]
    puts $file_id "M = $M"
    
    # Initialize the sum
    set sum 0

    # Creating the loop for M
    for {set j 1} {$j <= $M} {incr j} {
        set rand_num [expr { int(rand() * ($my_id + 1))}] 
        puts $file_id $rand_num
        set sum [expr {$sum + $rand_num}]
       
    }

    # Calculates and prints the average
    set avg [expr { double($sum) / $M }]

    puts $file_id "Average = $avg"
    puts $file_id ""
}
close $file_id

#===============================================

# Part B.2 - Parse and analyze the file

# Opening and reading the part1 file
set input [open "207704149.part1" r]
set result {}

# Reads the file line by line
while { [gets $input line] >= 0 } {
    puts $line

    # Detects number of runs
    if {[regexp {^Run Number: ([0-9]+)$} $line match num]} {
        set maximum 0
    }

    # Detects the random number
    if {[regexp {^[0-9]+$} $line]} {
        if {$line > $maximum} {
            set maximum $line
        }
    }

    # Detects the average
    if {[regexp {^Average = ([0-9.]+)$} $line match avg]} {
        lappend result [list $num $avg $maximum]
    }
}

#closing the part1 file
close $input

# Sort the results of the read by average (ascending)
set sorted_res [lsort -real -index 1 $result]

# Opens part2 file
set output [open "$my_id.part2" w]

# Writes the header for the file
puts $output "# EX_1 Rotem Golov 207704149 Orel Cohen 318733219"
puts $output "Run Number    Average       Maximum"
puts $output "------------  -------       -------"

# Writes the sorted results
foreach result $sorted_res {
    set num [lindex $result 0]
    set avg [lindex $result 1]
    set maximum [lindex $result 2]

    #foramting the file
    puts $output [format "%-14d%-14.1f%d" $num $avg $maximum]
}

close $output

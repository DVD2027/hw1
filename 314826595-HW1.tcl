# define var
set id 314826595
set file_part1 "${id}.part1"

# initialize the random number generator seed with the id for reproducible results
# every srand/rand command from this point onwards will be a modulo of the seed
expr { srand($id) }

# generate a new file with the exact name requested by the assignment
set fh1 [open $file_part1 w]

# the first line in the file - also defined through the readme
puts $fh1 "# EX_1 Idan Safadi 314826595 Bar zahavi 323014894"

# generate a random number between 10-20 the int helps us round up the number the rand will eval at [0,1) meaning we exist within the bounds
set N [expr { int(rand() * 11) + 10 }]
puts $fh1 "Number of runs: N = $N"

for {set i 1} {$i <= $N} {incr i} {
    puts $fh1 "Run Number: $i"
    puts $fh1 "-------------"

    #same as N generation but between 5-30 as requested
    set M [expr { int(rand() * 26) + 5 }]
    puts $fh1 "M = $M"

    #init sum to a floating point number so that the final avg will display as intended
    set sum 0.0

    # generating the random number using the predictable seed for the randum values that will be used for our avg using sum to accumulate the results
    for {set j 0} {$j < $M} {incr j} {
        set rand_val [expr { int(rand() * ($id + 1)) }]
        puts $fh1 $rand_val
        set sum [expr {$sum + $rand_val}]
    }

    # calculating the avg and using the currect formating
    set avg [format "%.1f" [expr {$sum / $M}]]
    puts $fh1 "Average = $avg"
    
    # filing an empty line to adhere to the format presented in the assignment
    puts $fh1 ""
}

# closing the file in order to commit the changes
close $fh1
#for our validation
puts "Part 1 completed! File $file_part1 was generated."

# ==========================================
# --- Part 2: Parsing and Analysis ---
# ==========================================

set file_part2 "${id}.part2"

# in order for us to parse the file we need to open it on read
set fh1 [open $file_part1 r]



# this list saves all of the runs history
set runs_list {}

set current_run ""
set current_max -1
set reading_numbers 0

# reading the file line by line
while { [gets $fh1 line] >= 0 } {
    # trims spaces
    set line [string trim $line]
    
    #ignore empty lines
    if { $line == "" } continue
    
    #regexp validates the existance of a pattern in a string
    #when using ^ we force the check to start from the first character
    #we use \s* to ignore spaces in the line
    #use () to save the argument for the second part of regex
    #the anotation of \d+ checks for the digit or in our case the run number for the input
    #we save the whole matching substring in match and the value stored in () in run_number
    #therefore we only enter the first initilizing if if we match a new run
    if { [regexp {^Run Number:\s*(\d+)} $line match run_num] } {
        set current_run $run_num
        set current_max -1
        set reading_numbers 0
    } elseif { [regexp {^M\s*=\s*\d+} $line] } {
        #from this point onwards we get our random generated numbers
        set reading_numbers 1
    } elseif { [regexp {^Average\s*=\s*([0-9.]+)} $line match avg] } {
        # now we'll save all of the arguments we will need for the output
        lappend runs_list [list $current_run $avg $current_max]
	#we know from the files format that here we need to stop finding the maximum for the current run (this is the last line)
        set reading_numbers 0
    } elseif { $reading_numbers == 1 } {
        # finding the maximum
        if { $line > $current_max } {
            set current_max $line
        }
    }
}
close $fh1

#here we use lsort where the index that interests us is 1 because we stored the avg there and save the output into the sorted_runs var
set sorted_runs [lsort -real -index 1 $runs_list]

# create the new file for the second part
set fh2 [open $file_part2 w]

#format helps us to adhere to the format presented in the exercize

puts $fh2 "# EX_1 Idan Safadi 314826595 Bar zahavi 323014894"
puts $fh2 [format "%-14s%-14s%s" "Run Number" "Average" "Maximum"]
puts $fh2 [format "%-14s%-14s%s" "------------" "-------" "-------"]

#printing the sorted itemized list
foreach item $sorted_runs {
    set r [lindex $item 0]
    set a [lindex $item 1]
    set m [lindex $item 2]
    puts $fh2 [format "%-14s%-14s%s" $r $a $m]
}
close $fh2

puts "Part 2 completed! File $file_part2 was generated."

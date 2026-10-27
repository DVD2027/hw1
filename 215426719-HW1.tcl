# HomeWork-1 Niv Karasenty 215426719

# Settings
set SEED 215426719
set MAX_VAL 215426719
set OUT_FILE_1 "215426719.part1"
set IN_FILE $OUT_FILE_1
set OUT_FILE_2 "215426719.part2"

# Creating helper functions
proc rand_int {lo hi} {
    return [expr {$lo + int(rand() * ($hi - $lo + 1))}]
}

# Part 1 Code

# Choosing the seed
expr {srand($SEED)}

# Creating the output file 
set f [open $OUT_FILE_1 w]

# Generating number of runs
set N [rand_int 10 20]

# Starting to add data to the file
puts $f "# EX_1 Niv Karaesnty 215426719"
puts $f "Number of runs: N = $N"

for {set run 1} {$run <= $N} {incr run} {
    set M [rand_int 5 30]
    puts $f "Run Number: $run"
    puts $f [string repeat "-" 20]

    # Generating each round of numbers
    set sum 0
    for {set i 0} {$i <= $M} {incr i} {
        set num [rand_int 0 $MAX_VAL]
        puts $f $num
        incr sum $num
    }

    # Finding the average
    set avg [expr {double($sum) / $M}]
    puts $f [format "Average: %.1f" $avg]
    puts $f ""
}

close $f

# Part 2 code
set records {}
set run ""

# The input file for this part is the input file from part 1
set f [open $IN_FILE r]

# Starting to read lines:
while {[gets $f line] >= 0} {
    set line [string trim $line]

    if {[regexp {^Run Number:\s(\d+)$} $line -> num]} {
        set run $num
        set nums {}
    } elseif {$run eq ""} {
        # Outside any run, skip line
        continue
    } elseif {[string is integer -strict $line]} {
        # Append numbers array with this number
        lappend nums $line
    } elseif {[regexp {^Average:\s(\S+)$} $line -> avg]} {
        # End of run, store the data
        set max [tcl::mathfunc::max {*}$nums]
        lappend records [list $run $avg $max]

        # Reset for next run
        set run ""
    }
    # Dashes and empty lines are ignored because the don't match any of the conditions above
}

# Close the input file
close $f

# Sort the recorde by average in ascending order
set sorted [lsort -real -index 1 $records]

# Write to the output file
set f [open $OUT_FILE_2 w]
puts $f "# EX_1 Niv Karaesnty 215426719"
puts $f [format "%-14s%-14s%s" "Run Number" "Average" "Maximum"]
puts $f [format "%-14s%-14s%s" [string repeat - 12] [string repeat - 7] [string repeat - 7]]

foreach rec $sorted {
    lassign $rec r a m                     ;# unpack the record into three variables
    puts $f [format "%-14s%-14.1f%s" $r $a $m]
}

close $f
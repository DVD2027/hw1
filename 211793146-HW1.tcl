# Student details
set id1 211793146
set name1 "Amit Ben Eliezer"
set id2 212709026
set name2 "Or Rachamim"


# Part 1 - generate random numbers and write them with their averages

# Seed the random number generator with the ID
expr {srand($id1)}

# Output file name for part 1
set Part1File "${id1}.part1"
# Open the file for writing
set fp1 [open $Part1File w]

# Header line with both partners
set header "# EX_1 $name1 $id1 $name2 $id2"
puts $fp1 $header

# N = number of runs, an integer between 10 and 20
set N [expr { int(rand() * 11) + 10 }]

# Write N to the file
puts $fp1 "Number of runs: N = $N"

# Main loop - one iteration per run
for {set i 1} {$i <= $N} {incr i} {
    
    # Blank line between runs (not before the first one)
    if {$i > 1} {
        puts $fp1 ""
    }
    
    # Run header
    puts $fp1 "Run Number: $i"
    puts $fp1 "-------------"
    
    # M = amount of numbers in this run, between 5 and 30
    set M [expr { int(rand() * 26) + 5 }]
    puts $fp1 "M = $M"
    
    set sum 0
    
    # Generate M random integers between 0 and the ID
    for {set j 0} {$j < $M} {incr j} {
        set val [expr { int(rand() * ($id1 + 1)) }]
        puts $fp1 $val
        # Add the new value to the running sum
        set sum [expr { $sum + $val }]
    }
    
    # Average of the run, printed with one decimal digit
    set avg [expr { double($sum) / $M }]
    puts $fp1 [format "Average = %.1f" $avg]
}

close $fp1





# Part 2 - parse part 1 file and write the sorted summary

# Output file name for part 2
set Part2File "${id1}.part2"

# Open the part 1 file for reading
set fp1 [open $Part1File r]

# List of {RunNumber Average Maximum} for all runs
set RunsList {}

# Track the current run while parsing
set CurrentRun ""
set CurrentMax -1

# Read the file line by line
while {[gets $fp1 line] >= 0} {

    # Run header line - capture the run number
    if {[regexp {^Run Number:\s+(\d+)} $line match RunId]} {

        set CurrentRun $RunId
        # Reset the maximum for the new run
        set CurrentMax -1
    
    # Average line - capture the average, the run is complete
    } elseif {[regexp {^Average =\s+([\d\.]+)} $line match RunAvg]} {

        lappend RunsList [list $CurrentRun $RunAvg $CurrentMax]
        
    # A line with a single integer - one of the random numbers
    } elseif {[regexp {^\d+$} $line]} {
        # Keep the largest number seen in this run
        if {$CurrentMax == -1 || $line > $CurrentMax} {
            set CurrentMax $line
        }
    }
}

close $fp1

# Sort runs by average, ascending (index 1, compared as real numbers)
set SortedRuns [lsort -real -index 1 $RunsList]

# Open the part 2 file for writing
set fp2 [open $Part2File w]

# Same header as part 1
puts $fp2 $header

# Column titles - left-aligned, 14 characters per column
puts $fp2 [format "%-14s%-14s%s" "Run Number" "Average" "Maximum"]
puts $fp2 [format "%-14s%-14s%s" "------------" "-------" "-------"]

# Write one row per run, in sorted order
foreach run $SortedRuns {
    
    # Run number, average and maximum of this run
    set r [lindex $run 0]
    set a [format "%.1f" [lindex $run 1]]
    set m [lindex $run 2]
    
    puts $fp2 [format "%-14s%-14s%s" $r $a $m]
}

close $fp2

#hw 1
#Part 1 
set id 322819392
set studentDetails "Yonatan Ben Bassat 322819392 Itay Refaeli 207883950"
#setting random number 
expr {srand($id)}
#generating N according 
set N [expr {int(rand() * 11) +10}]

#generating output
set fh [open "${id}.part1" w]
puts $fh "# EX_1 $studentDetails"
puts $fh "Number of runs: N = $N"

#for loop 
for {set i 1} {$i <= $N} {incr i} {
    set M [expr {int(rand() * 26) + 5}]
    puts $fh "Run Number: $i"
    puts $fh "-------------"
    puts $fh "M = $M"
    set sum 0
    #Inner loop
    for {set j 1} {$j <= $M} {incr j} {
    	set val [expr {int(rand() * ($id + 1.0))}]
    	puts $fh $val
    	set sum [expr {$sum + $val}]    	
    }
    #Calculating average
    set avg [expr {double($sum) / $M}]
    puts $fh [format "Average = %.1f" $avg]
    if {$i < $N} {
    	puts $fh ""
	}
}
close $fh


#Part 2 - parsing results
set fh [open "${id}.part1" r]
set results {}

# Read Part 1 file, making sure that we got any result
while {[gets $fh line] >= 0} {
    # Get run number - making sure that we've began to read a legit run
    if {[regexp {^Run Number: ([0-9]+)$} $line -> run]} {
        continue
    }
    # Get M and find maximum
    if {[regexp {^M = ([0-9]+)$} $line -> M]} {
        set maxNum 0
        #Going through the run to find max value
        for {set j 0} {$j < $M} {incr j} {
            gets $fh num
            if {$num > $maxNum} {set maxNum $num}
        }
	#Get avg and save the results
    } elseif {[regexp {^Average = ([0-9]+[.][0-9]+)$} $line -> avg]} {
        lappend results [list $run $avg $maxNum]
    }
}

close $fh

# Create sorted output
set fh [open "${id}.part2" w]
puts $fh "# EX_1 $studentDetails"
puts $fh [format "%-14s%-14s%s" "Run Number" "Average" "Maximum"]
puts $fh [format "%-14s%-14s%s" "------------" "-------" "-------"]

foreach row [lsort -real -index 1 $results] {
    lassign $row run avg maxNum
    puts $fh [format "%-14s%-14s%s" $run $avg $maxNum]
}

close $fh

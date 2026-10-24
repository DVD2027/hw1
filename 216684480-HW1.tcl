set ID 216684480

#----------------------- Part 1 -----------------------
expr { srand($ID) }
set N [expr {int(rand()*(11)+10)}]; #sets N from 10-20

set fh [open "$ID.part1" w]
puts $fh "# EX_1 Yehoshua Strauss $ID"
puts $fh "Number of runs: N = $N"

set i 1
while {$i <= $N} {
    puts $fh "Run Number: $i"
    puts $fh "-------------"

    set M [expr {int(rand()*(26)+5)}]; #sets M from 5-30
    puts $fh "M = $M"

    set numbers {}; #generate an empty list for the numbers
    for {set j 0} {$j < $M} {incr j} {
        lappend numbers [expr {int(rand()*($ID+1))}]
    }

    #After generating M numbers we'll calculate the sum
    set sum 0
    foreach x $numbers {
        # we'll use the loop to both calculate the sum and write the numbers in the file
        puts $fh "$x"
        set sum [expr {$sum+$x}]
    }
    set avg [expr {double($sum)/ [llength $numbers]}]

    puts $fh "Average = [format {%0.1f} $avg]"

    # add an empty line after each run except the last
    if {$i < $N} {
        puts $fh ""
    }

    incr i
}

close $fh

#----------------------- Part 2 -----------------------
#we'll make a list of lists that contains for each run the {run number, max, average}
set data {}

set fh [open "$ID.part1" r]

# now we read line by line
while {[gets $fh line] >=0} {
    if {[regexp {^Run Number: (\d+)} $line -> runNum]} {
        set max -1; # so that it doesnt have the last runs maximum
    } elseif {[regexp {^(\d+)$} $line -> num]} {
        if {$num > $max} {set max $num}
    } elseif {[regexp {^Average = (.+)$} $line -> avg]} {
        lappend data [list $runNum $max $avg]; #after the run is finished (since average is at the end of each run)
        # save its values
    }
}

close $fh

# now we need to sort the list by the average which is in index 2
set sorted_data [lsort -real -index 2 $data]

set fl [open "$ID.part2" w]
puts $fl "# EX_1 Yehoshua Strauss $ID"
puts $fl [format "%-14s%-14s%s" "Run Number" "Average" "Maximum"]
puts $fl [format "%-14s%-14s%s" "------------" "-------" "-------"]
foreach run $sorted_data {
    lassign $run r m a; #r = run number, m = maximum, a = average
    puts $fl [format "%-14s%-14s%s" $r $a $m]
}

close $fl

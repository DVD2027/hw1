set out [open "316301670.part1" w]

puts $out  "# EX_1 Miryam Zurel 316301670"

 # seed the pseudo-random generator
set ID 316301670
expr {srand($ID)}   

 #random integer 10..20
set N [expr {10 + int(rand() * 11)}]
puts $out "Number of runs: N = $N"


set i 1 ;#outer loop counter

#outer loop: iterates the number of runs N times
while {$i <= $N} {

puts $out "Run Number: $i"
puts $out "-------------"

 #random integer 5..30
set M [expr {5 + int(rand()*26)}]
puts $out "M = $M"

set j 0 ;#inner loop counter
set sum 0


#inner loop: prints random numbers M times within the range of ID
while {$j < $M} {

set R [expr {int(rand() * ($ID +1))}] ;# random integer 0..ID 

set sum [expr {$sum + $R}]

puts $out "$R"

incr j
}


# Calculate average
set average [expr {double($sum) / $M }]
puts $out [format "Average = %.1f" $average]
puts $out ""


incr i
}

close $out


#part 2
set out2 [open "316301670.part2" w]

puts $out2 "# EX_1 Miryam Zurel 316301670"

puts $out2 "Run Number    Average       Maximum"

puts $out2 "------------  -------       -------"

set input [open "316301670.part1" r]  ;# open for reading

set myList {}

while { [gets $input line] >= 0 } { ;# read line by line

	if { [string match "Run Number:*" $line] } { 

	set runNumber [lindex $line 2]

	set currentMax 0

	} elseif { [string is integer $line] } {

		if { $line > $currentMax } {
		set currentMax $line
		}

	} elseif {[string match "Average = *" $line] } { 

	set aveNumber [lindex $line 2]

lappend myList [list $runNumber $aveNumber $currentMax ]

	}

      }

set sortedList [lsort -real -index 1 $myList]

set k 0
while { $k < [ llength $sortedList] } {

set record [lindex $sortedList $k]
set runNumber [lindex $record 0]
set aveNumber [lindex $record 1]
set currentMax [lindex $record 2]

puts $out2 [format "%-14s%-14s%s" $runNumber $aveNumber $currentMax]

incr k

}

close $input
close $out2

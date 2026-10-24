expr { srand(325024123) }

set part1 [open "325024123.part1" w]
puts $part1 "# EX_1 Michelle Levi 325024123"

set N [expr {int(rand()*11) + 10}] 
puts $part1 "Number of runs: N = $N"

for { set i 0 } { $i < $N } { incr i } { 
	puts $part1 "Run Number: [expr $i+1]"
	puts $part1 "-------------"
	
	set M [expr {int(rand()*26) + 5}]
	puts $part1 "M = $M"

	set sum 0
	
	for { set j 0 } { $j < $M } { incr j } {
		set randnum [expr {int(rand()*(325024123+1))}]
		puts $part1 $randnum
		set sum [expr {$sum + $randnum}]
	}

	set average [format {%.1f} [expr {double($sum)/$M}]]
	puts $part1 "Average = $average"

	if { $i < $N-1 } {
		puts $part1 ""
	}
 }

 close $part1

 set part1 [open "325024123.part1" r]
 set part2 [open "325024123.part2" w]

 puts $part2 "# EX_1 Michelle Levi 325024123"
 puts $part2 "Run Number    Average       Maximum"
 puts $part2 "------------  -------       -------"

 set results {}
 set run 0
 set maximum 0

 while {[gets $part1 line] >= 0} {
	
	if {[regexp {^Run Number: ([0-9]+)$} $line match number]} {
		set run $number
		set maximum 0
	}

	if {[regexp {^[0-9]+$} $line]} {
		if {$line > $maximum} {
			set maximum $line
		}
	}

	if {[regexp {^Average = (.+)$} $line match average]} {
		lappend results [list $average $run $maximum]
	}
 }

close $part1

set results [lsort -real -index 0 $results]

foreach result $results {
	set average [lindex $result 0]
	set run [lindex $result 1]
	set maximum [lindex $result 2]

	puts $part2 [format "%-14s%-14s%s" $run $average $maximum]
}

close $part2
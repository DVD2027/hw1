
set id 324937226
set name "Kinanah Haneif"
set partner_id 207719600
set partner_name "Jobran Khateeb"

expr {srand($id)}
set N [expr {10 + int(rand() * 11)}]

set fh [open "${id}.part1" w]
puts $fh "# EX_1 $name $id $partner_name $partner_id"
puts $fh "Number of runs: N = $N"

for {set run 1} {$run <= $N} {incr run} {
set M [expr {5 + int(rand() * 26)}]
	set sum 0
	
	puts $fh "Run Number: $run"
	puts $fh "-------------"
	puts $fh "M = $M"

	for {set j 0} {$j < $M} {incr j} {
	    set value [expr {int(rand() * ($id + 1))}]
        puts $fh $value
        set sum [expr {$sum + $value}]
    }

    set average [expr {double($sum) / $M}]
    puts $fh "Average = $average"
    puts $fh ""
}
close $fh


# Part 2: read and parse Part 1
set input [open "${id}.part1" r]
gets $input header
gets $input line
scan $line "Number of runs: N = %d" number_of_runs

set results {}

for {set r 0} {$r < $number_of_runs} {incr r} {
    while {[gets $input line] >= 0} {
        if {[string trim $line] ne ""} {
            break
        }
    }

    scan $line "Run Number: %d" run_number

    gets $input line
    gets $input line
    scan $line "M = %d" count

    set maximum -1
    for {set j 0} {$j < $count} {incr j} {
        gets $input value
        if {$value > $maximum} {
            set maximum $value
        }
    }

    gets $input line
    set average [string trim [lindex [split $line "="] 1]]
    lappend results [list $run_number $average $maximum]
}

close $input

set results [lsort -real -index 1 $results]

set output [open "${id}.part2" w]
puts $output $header
puts $output "Run Number    Average       Maximum"
puts $output "------------  -------       -------"

foreach result $results {
    puts $output [format "%-12s  %-11s  %s" \
        [lindex $result 0] \
        [lindex $result 1] \
        [lindex $result 2]]
}

close $output

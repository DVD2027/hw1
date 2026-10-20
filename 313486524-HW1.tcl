#EX_1 Shimi Hershkovitz 313486524 Shaul Gita 315545640

#Part 1

set N 10
set ID 313486524
set header "# EX_1 Shimi Hershkovitz 313486524 Shaul Gita 315545640"
set min_M 5
set max_M 30

set fh [open 313486524.part1 w]
puts $fh "$header"
puts $fh "Number of runs: N = [format "%d" $N]"

expr {srand($ID)}

for {set i 0} {$i < $N} {incr i} {
    set temp 0
    set sum 0
    set avg 0
    puts $fh "Run Number: [format "%d" [expr $i+1]]"
    puts $fh "-------------"
    set M [expr {$min_M + int(rand()*($max_M - $min_M))}]
    puts $fh "M = [format "%d" $M]"
    for {set j 0} {$j < $M} {incr j} {
        set temp [expr {int(rand()*($ID + 1))}]
	set sum [expr $temp + $sum]
	puts $fh "[format "%d" $temp]"		  
    }
    set avg [expr {double($sum) / $M}]
    puts $fh "Average = [format "%0.1f" $avg]"
    puts $fh ""
}

close $fh

# Part 2

set records {}
set max_num 0

set fh [open 313486524.part1 r]
while { [gets $fh line] >= 0 } {

    regexp {Run Number: ([0-9]+)} $line match run_num

    if { [regexp {^([0-9]+)$} $line match rand_num]} {
	if {$rand_num > $max_num} {
	    set max_num $rand_num
	}
    }
    if { [regexp {Average = ([0-9]+\.[0-9])} $line match avg]} {
	lappend records [list $run_num $avg $max_num]
	set max_num 0
    }
    
}

close $fh

set records [lsort -real -increasing -index 1 $records]

set fh [open 313486524.part2 w]

puts $fh "$header"
puts $fh [format {%-14s%-14s%s} "Run Number" "Average" "Maximum"]
puts $fh [format {%-14s%-14s%s} "------------" "-------" "-------"]

foreach record $records {
    puts $fh [format {%-14d%-14s%s} [lindex $record 0] [lindex $record 1] [lindex $record 2]]
}

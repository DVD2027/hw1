;# PART A
set fh [open "330742370.part1" w]
puts $fh "# EX_1 Ofri Bichkov-Shoshany 330742370 Yael Cohen 329579833"

expr {srand(330742370)}

proc rand_int {low high} {
    return [expr { $low + int(rand()*($high - $low +1))}]
}

set N [rand_int 10 20]

puts $fh "Number of runs: N = $N"

set i 1

while {$i <= $N} {
    puts $fh "Run Number: $i"
    puts $fh "-------------"
    incr i 
    set M [rand_int 5 30]
    puts $fh "M = $M"
    set sum 0
    for {set j 1 } {$j <= $M } {incr j} {
        set r [rand_int 0 330742370]
        puts $fh "$r"
        incr sum $r
    }
    set avg [ expr {double($sum)/$M}]
    set avg [ format {%0.1f} $avg ]
    puts $fh "Average = $avg"
    puts $fh ""
    
    }

close $fh

;# PART B
set fh [open "330742370.part2" w]
set fh_ [open "330742370.part1" r]
puts $fh "# EX_1 Ofri Bichkov-Shoshany 330742370 Yael Cohen 329579833"
puts $fh [format {%-14s%-14s%s} "Run Number" "Average" "Maximum"]
puts $fh [format {%-14s%-14s%s} "------------" "-------" "-------"]

set reading 0
while { [gets $fh_ line] >= 0 } {
    if { [regexp {^Run Number: (\d+)$} $line -> run] } {
        set reading 0
    } elseif { [regexp {^M = \d+$} $line] } {
        set reading 1
        set curr_max -1
    } elseif { $reading && [regexp {^\d+$} $line] } {
        set curr_max [expr {max($curr_max, $line)} ]
    } elseif { [regexp {^Average = (\S+)$} $line -> avg] } {
        set max($run) $curr_max
        lappend run_of($avg) $run
        set reading 0
    }
}

close $fh_

foreach avg [lsort -real [array names run_of]] {
    foreach run $run_of($avg) {
        puts $fh [format {%-14s%-14s%s} $run $avg $max($run)]
    }
}

close $fh

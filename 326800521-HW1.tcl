# ---------- settings ----------
set id 326800521
set header "# EX_1 Nour Alemy 326800521 Nagham Khatib 325394989"
expr { srand($id) }

# ---------- Part 1 ----------
set fh [open "${id}.part1" w]
puts $fh $header

set N [expr { 10 + int(rand()*11) }]
puts $fh "Number of runs: N = $N"

for { set r 1 } { $r <= $N } { incr r } {
    puts $fh "Run Number: $r"
    puts $fh "-------------"
    set M [expr { 5 + int(rand()*26) }]
    puts $fh "M = $M"
        set sum 0
    for { set i 1 } { $i <= $M } { incr i } {
        set x [expr { int(rand()*($id + 1)) }]
        puts $fh $x
        set sum [expr { $sum + $x }]
    }
      
      puts $fh "Average = [format %.1f [expr { double($sum) / $M }]]"   
      puts $fh ""
}
close $fh


# ---------- Part 2 ----------
set results {}
set fh [open "${id}.part1" r]
while { [gets $fh line] >= 0 } {
    if { [regexp {^Run Number: (\d+)$} $line -> run] } {
        set max -1
    } elseif { [regexp {^(\d+)$} $line -> num] } {
        if { $num > $max } { set max $num }
    } elseif { [regexp {^Average = (\S+)$} $line -> avg] } {
        lappend results [list $run $avg $max]
    }
}
close $fh
set sorted [lsort -real -index 1 $results]

set fh [open "${id}.part2" w]
puts $fh $header
puts $fh [format {%-14s%-14s%s} "Run Number" "Average" "Maximum"]
puts $fh [format {%-14s%-14s%s} "------------" "-------" "-------"]
foreach item $sorted {
    puts $fh [format {%-14s%-14s%s} [lindex $item 0] [lindex $item 1] [lindex $item 2]]
}
close $fh

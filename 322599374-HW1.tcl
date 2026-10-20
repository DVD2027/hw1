# HW1 - Digital VLSI Design 83-612
# Part 1: generate random runs and averages -> <ID>.part1
# Part 2: parse <ID>.part1, sort by average   -> <ID>.part2

# ---- Pair details (representative ID = branch name = seed) ----
set ID     "322599374"
set header "# EX_1 Gilad Buskila 322599374 Daniel Gavra 322402108"

# ==========================================================
# Part 1
# ==========================================================
expr { srand($ID) }                         ;# seed with the ID

set N [expr { 10 + int(rand()*11) }]        ;# N in 10..20

set fh [open "$ID.part1" w]
puts $fh $header
puts $fh "Number of runs: N = $N"

for { set r 1 } { $r <= $N } { incr r } {
    set M [expr { 5 + int(rand()*26) }]     ;# M in 5..30
    puts $fh "Run Number: $r"
    puts $fh "-------------"
    puts $fh "M = $M"

    set sum 0
    for { set i 0 } { $i < $M } { incr i } {
        set v [expr { int(rand()*($ID+1)) }] ;# value in 0..ID
        puts $fh $v
        incr sum $v
    }
    puts $fh "Average = [format %.1f [expr { double($sum)/$M }]]"

    if { $r < $N } { puts $fh "" }          ;# blank line between runs
}
close $fh

# ==========================================================
# Part 2 - parse the .part1 file (not the values in memory)
# ==========================================================
set runs {}
set fh [open "$ID.part1" r]
while { [gets $fh line] >= 0 } {
    if { [regexp {^Run Number: (\d+)$} $line -> run] } {
        set max -1
    } elseif { [regexp {^\d+$} $line] } {
        if { $line > $max } { set max $line }
    } elseif { [regexp {^Average = (\S+)$} $line -> avg] } {
        lappend runs [list $run $avg $max]
    }
}
close $fh

set runs [lsort -real -index 1 $runs]       ;# ascending by average

set fh [open "$ID.part2" w]
puts $fh $header
puts $fh [format "%-14s%-14s%s" "Run Number"   "Average" "Maximum"]
puts $fh [format "%-14s%-14s%s" "------------" "-------" "-------"]
foreach r $runs {
    lassign $r run avg max
    puts $fh [format "%-14s%-14s%s" $run $avg $max]
}
close $fh

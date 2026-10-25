# ID-HW1.tcl - HW1: Tcl running average + parsing
# Oren Ruthstein 330944455
# Run with: tclsh ID-HW1.tcl

set ID     330944455
set header "# EX_1 Oren Ruthstein $ID"

# =============================================================================
# Part 1: generate N runs of M random numbers and their averages
# =============================================================================

# Random integer in [min, max] (both included)
proc rand_int { min max } {
    return [expr {$min + int(rand() * ($max - $min + 1))}]
}

expr {srand($ID)}

set fh [open "$ID.part1" w]
puts $fh $header

set N [rand_int 10 20]
puts $fh "Number of runs: N = $N"

for {set run 1} {$run <= $N} {incr run} {
    puts $fh "Run Number: $run"
    puts $fh "-------------"

    set M [rand_int 5 30]
    puts $fh "M = $M"

    set sum 0
    for {set i 0} {$i < $M} {incr i} {
        set value [rand_int 0 $ID]
        puts $fh $value
        set sum [expr {$sum + $value}]
    }
    # double() avoids integer division; %.1f = one decimal, as in the spec
    set avg [expr {double($sum) / $M}]
    puts $fh "Average = [format %.1f $avg]"
    puts $fh ""
}
close $fh

# =============================================================================
# Part 2: parse the .part1 file, sort runs by average, report the maximum
# =============================================================================

set runs {}
set fh [open "$ID.part1" r]
while {[gets $fh line] >= 0} {
    if {[regexp {^Run Number: (\d+)} $line -> run]} {
        set max -1
    } elseif {[regexp {^\d+$} $line]} {
        if {$line > $max} { set max $line }
    } elseif {[regexp {^Average = (\S+)} $line -> avg]} {
        lappend runs [list $run $avg $max]
    }
}
close $fh

set fh [open "$ID.part2" w]
puts $fh $header
puts $fh [format {%-14s%-14s%s} "Run Number" "Average" "Maximum"]
puts $fh [format {%-14s%-14s%s} "------------" "-------" "-------"]
foreach r [lsort -real -index 1 $runs] {
    lassign $r run avg max
    puts $fh [format {%-14s%-14s%s} $run $avg $max]
}
close $fh

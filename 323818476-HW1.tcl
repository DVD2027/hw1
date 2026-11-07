#!/usr/bin/env tclsh
# =============================================================================
# HW1 - The Tool Command Language (Tcl)
#   Part 1: N runs, each run draws M random numbers and prints their average
#           into <ID>.part1
#   Part 2: parses <ID>.part1 and writes the runs sorted by average
#           (ascending) with the maximum of each run into <ID>.part2
#
# Run it with:   tclsh 323818476-HW1.tcl
# =============================================================================

# ---- Partners (ID1 = the representative: seed, file names and branch) -------
# Leave NAME2/ID2 empty when submitting alone.
set NAME1 "Eden Efimov"
set ID1   "323818476"
set NAME2 ""
set ID2   ""

# ---- Parameters --------------------------------------------------------------
set N_MIN 10
set N_MAX 20
set M_MIN 5
set M_MAX 30

set header     "# EX_1 $NAME1 $ID1"
if { $NAME2 ne "" } {
    append header " $NAME2 $ID2"
}
set part1_file "${ID1}.part1"
set part2_file "${ID1}.part2"

# An ID may start with 0, which expr would read as an (invalid) octal number,
# so convert it to a decimal integer once and use that everywhere.
scan $ID1 %d id_value

# Random integer in the range [min, max] (both ends included)
proc rand_range { min max } {
    return [expr { $min + int(rand() * ($max - $min + 1)) }]
}

# =============================================================================
# Part 1: generate the runs
# =============================================================================
expr { srand($id_value) }                       ;# seed with our ID

set N [rand_range $N_MIN $N_MAX]

set fh [open $part1_file w]
fconfigure $fh -translation lf                 ;# Unix line endings on any OS
puts $fh $header
puts $fh "Number of runs: N = $N"

for { set run 1 } { $run <= $N } { incr run } {
    set M [rand_range $M_MIN $M_MAX]
    set sum 0
    puts $fh "Run Number: $run"
    puts $fh "-------------"
    puts $fh "M = $M"
    for { set i 0 } { $i < $M } { incr i } {
        set value [rand_range 0 $id_value]
        puts $fh $value
        set sum [expr { $sum + $value }]
    }
    puts $fh [format "Average = %.1f" [expr { double($sum) / $M }]]
    if { $run < $N } {
        puts $fh ""                             ;# blank line between runs
    }
}
close $fh

# =============================================================================
# Part 2: parse <ID>.part1 (not the values in memory) and summarize
# =============================================================================
set runs {}                                     ;# list of {run average max}
set run_number ""
set max_value  ""

set fh [open $part1_file r]
while { [gets $fh line] >= 0 } {
    set line [string trim $line]
    if { [regexp {^Run Number:\s*(\d+)$} $line -> number] } {
        set run_number $number
        set max_value  ""
    } elseif { [regexp {^Average\s*=\s*(\S+)$} $line -> average] } {
        lappend runs [list $run_number $average $max_value]
    } elseif { [regexp {^\d+$} $line] && $run_number ne "" } {
        if { $max_value eq "" || $line > $max_value } {
            set max_value $line
        }
    }
}
close $fh

set runs [lsort -real -increasing -index 1 $runs]

set fh [open $part2_file w]
fconfigure $fh -translation lf
puts $fh $header
puts $fh [format {%-14s%-14s%s} "Run Number" "Average" "Maximum"]
puts $fh [format {%-14s%-14s%s} "------------" "-------" "-------"]
foreach run $runs {
    lassign $run run_number average max_value
    puts $fh [format {%-14s%-14s%s} $run_number $average $max_value]
}
close $fh

puts "Wrote $part1_file ([llength $runs] runs) and $part2_file"

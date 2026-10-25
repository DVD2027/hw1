# HW1 - Tcl: random values and parsing
set representativeName "BeatriceSuhoy"
set representativeID "315941120"
set partnerName "TommyLevi"
set partnerID "319020301"

# Both output files must use the same heading.
set heading "# EX_1 $representativeName $representativeID $partnerName $partnerID"
set part1Filename "${representativeID}.part1"
set part2Filename "${representativeID}.part2"

# Scan %d as a decimal integer, even when the ID begins with 0.
if {![regexp {^[0-9]+$} $representativeID]} {
    error "Representative ID must contain digits only"
}
scan $representativeID %d numericID
expr {srand($numericID)}

# PART 1: Write random runs and their averages.
	# rand rives R number
set N [expr {10 + int(rand() * 11)}]
set out [open $part1Filename w]
puts $out $heading
puts $out "Number of runs: N = $N"

for {set run 1} {$run <= $N} {incr run} {
    set M [expr {5 + int(rand() * 26)}]
    puts $out "Run Number: $run"
    puts $out "-------------"
    puts $out "M = $M"

    set sum 0
    for {set j 0} {$j < $M} {incr j} {
        set value [expr {int(rand() * ($numericID + 1))}]
        puts $out $value
        set sum [expr {$sum + $value}]
    }
    set average [expr {double($sum) / $M}]
    puts $out "Average = $average"
    if {$run < $N} {
        puts $out ""
    }
}
close $out

# PART 2: Read and parse the saved file (not Part 1's memory values).
set in [open $part1Filename r]
set rows {}
set currentRun 0
set currentMaximum -1
while {[gets $in line] >= 0} {
    if {[regexp {^Run Number: ([0-9]+)$} $line -> parsedRun]} {
        set currentRun $parsedRun
        set currentMaximum -1
    } elseif {[regexp {^Average = (.+)$} $line -> parsedAverage]} {
        lappend rows [list $parsedAverage $currentRun $currentMaximum]
    } elseif {[regexp {^[0-9]+$} $line] && $currentRun > 0} {
        if {$line > $currentMaximum} {
            set currentMaximum $line
        }
    }
}
close $in

set out [open $part2Filename w]
puts $out $heading
puts $out [format "%-14s%-14s%s" "Run Number" "Average" "Maximum"]
puts $out [format "%-14s%-14s%s" "------------" "-------" "-------"]
foreach row [lsort -real -index 0 $rows] {
    lassign $row average run maximum
    # Keep the example's 14-character columns, but do not join
    # a long average to the maximum when it exceeds column width.
    if {[string length $average] >= 14} {
        set averageColumn "$average "
    } else {
        set averageColumn [format "%-14s" $average]
    }
    puts $out "[format %-14s $run]${averageColumn}$maximum"
}
close $out

puts "Created $part1Filename and $part2Filename"

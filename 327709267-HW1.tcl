expr {srand(327709267)}
proc randomize { min max } {
set r [expr {$min + int(rand() * ($max - $min + 1))}] 
return $r
}

set acc 0
set M 0
set element 0

set fh1 [open "327709267.part1" w]; # For overwriting
puts $fh1 "# EX_1 Amit Karadi 214881088 Carmel Tamir 327709267"

set N [randomize 10 20]; # Randomizing N between 10 to 20
puts $fh1 "Number of runs: N = $N"
for {set i 1} {$i <= $N} {incr i} {
    set M [randomize 5 30]
    puts $fh1 "Run Number: $i"
    puts $fh1 "-------------"
    puts $fh1 "M = $M"; #exact formatting
    for {set j 0} {$j < $M} {incr j} {
        
        set element [randomize 0 327709267]
        puts $fh1 "$element"
        set acc [expr $acc + $element]
    }

    puts $fh1 "Average = [format "%.1f" [expr {double($acc) / $M}]]"
    if {$i < $N} { puts $fh1 "" }; # blank line only between runs, not after the last one
    set acc 0
}
close $fh1

set fh1 [open "327709267.part1" r]; # For reading

set averages {}
set maximum {}
set current_max 0
set current_average 0

while { [gets $fh1 line] >= 0 } { ;# read line by line
    if { [regexp {^Average = (\S+)} $line temp current_average] } {; # Checking for lines starting with Average

        lappend averages $current_average
        lappend maximum $current_max
        set current_max 0; # we first collect all the averages into a list

    } elseif { [regexp {^\d+$} $line val] } {; # Checking for lines containing only digits
        if { $val > $current_max } { set current_max $val }; # finding max
    }
}

close $fh1
set fh2 [open "327709267.part2" w]; # changing open file to write into .part2 file

set min_average 327709268; # this is above the max possible average
set min_index 0
set rep [llength $averages]; # we use a nested loop, rep being the length of averages

puts $fh2 "# EX_1 Amit Karadi 214881088 Carmel Tamir 327709267"
puts $fh2 "Run Number    Average       Maximum"
puts $fh2 "------------  -------       -------"; # exact formatting

for {set i 0} {$i < $rep} {incr i} {
    
    for {set j 0} {$j < $rep} {incr j} {
        if {$min_average > [lindex $averages $j]} {
            set min_average [lindex $averages $j]
            set min_index $j; # finding lowest average
        }
    }
puts $fh2 [format {%-13s %-13s %s} [expr {$min_index + 1}] [lindex $averages $min_index] [lindex $maximum $min_index]]; # exact output formatting
set min_average 327709268; # resetting 
set averages [lreplace $averages $min_index $min_index 327709268]; # this command replaces the list "averages" with an idetical list, the only difference being that the indexes min_index to min_index are replaced with 327709268
}

close $fh2
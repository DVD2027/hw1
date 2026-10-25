set id 211881446
set header "# EX_1 Lahav Mordechai $id"

set part1_file "${id}.part1"
set part2_file "${id}.part2"

# Seed the generator with ID
expr { srand($id) }

# Part 1
# ======

set N [expr { 10 + int(rand() * 11) }]

set f1 [open $part1_file w]
puts $f1 $header
puts $f1 "Number of runs: N = $N"

for {set i 1} {$i <= $N} {incr i} {
    set M [expr { 5 + int(rand() * 26) }]
    puts $f1 "Run Number: $i"
    puts $f1 "-------------"
    puts $f1 "M = $M"
    
    set sum 0
    for {set j 0} {$j < $M} {incr j} {
        set val [expr { int(rand() * ($id + 1)) }]
        puts $f1 $val
        set sum [expr { $sum + $val }]
    }
    
    set avg [expr { double($sum) / $M }]
    puts $f1 "Average = $avg"
    puts $f1 ""
}
close $f1

# Part 2
# ======

set runs {}
set f1 [open $part1_file r]

set cur_run ""
set cur_max -1

while {[gets $f1 line] >= 0} {
    set line [string trim $line]
    if {[string match "Run Number: *" $line]} {
        set cur_run [lindex $line end]
        set cur_max -1
    } elseif {[string match "Average = *" $line]} {
        set cur_avg [lindex $line end]
        lappend runs [list $cur_run $cur_avg $cur_max]
    } elseif {[regexp {^\d+$} $line]} {
        set val [expr {wide($line)}]
        if {$cur_max == -1 || $val > $cur_max} {
            set cur_max $val
        }
    }
}
close $f1

# Sort runs by Average (ascending)
set sorted_runs [lsort -real -index 1 $runs]

# Write Part 2 file
set f2 [open $part2_file w]
puts $f2 $header
puts $f2 [format {%-14s%-28s%s} "Run Number" "Average" "Maximum"]
puts $f2 [format {%-14s%-28s%s} "------------" "-------" "-------"]

foreach run $sorted_runs {
    set r_num [lindex $run 0]
    set r_avg [lindex $run 1]
    set r_max [lindex $run 2]
    puts $f2 [format {%-14s%-28s%s} $r_num $r_avg $r_max]
}
close $f2
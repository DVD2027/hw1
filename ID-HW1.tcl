set rep_id 212706113
set header_line "# EX_1 Tomer Buda 212706113 Ohad Rosenblum 326338027"

set part1_file "${rep_id}.part1"
set part2_file "${rep_id}.part2"

# Part 1: Calculate a running average
scan $rep_id "%d" seed_val
expr { srand($seed_val) }

set N [expr { 10 + int(rand() * 11) }]

set fh1 [open $part1_file w]
puts $fh1 $header_line
puts $fh1 "Number of runs: N = $N"

for { set run 1 } { $run <= $N } { incr run } {
    puts $fh1 "Run Number: $run"
    puts $fh1 "-------------"
    
    set M [expr { 5 + int(rand() * 26) }]
    puts $fh1 "M = $M"
    
    set sum 0.0
    for { set j 0 } { $j < $M } { incr j } {
        set val [expr { int(rand() * ($seed_val + 1)) }]
        puts $fh1 $val
        set sum [expr { $sum + $val }]
    }
    
    set avg [format "%.1f" [expr { double($sum) / $M }]]
    puts $fh1 "Average = $avg"
    
    if { $run < $N } {
        puts $fh1 ""
    }
}
close $fh1

# Part 2: Parse and analyze the file
set fh1_read [open $part1_file r]

set runs_data {}
set current_run ""
set current_max -1
set header_from_file ""

while { [gets $fh1_read line] >= 0 } {
    set line [string trim $line]
    
    if { [string match "# EX_1*" $line] } {
        set header_from_file $line
    } elseif { [regexp {^Run Number:\s+(\d+)$} $line -> r_num] } {
        set current_run $r_num
        set current_max -1
    } elseif { [regexp {^Average\s*=\s*([0-9.]+)$} $line -> avg_val] } {
        lappend runs_data [list $current_run $avg_val $current_max]
    } elseif { [regexp {^\d+$} $line] } {
        if { $line > $current_max } {
            set current_max $line
        }
    }
}
close $fh1_read

set sorted_runs [lsort -real -index 1 $runs_data]

set fh2 [open $part2_file w]
puts $fh2 $header_from_file
puts $fh2 [format "%-14s%-14s%s" "Run Number" "Average" "Maximum"]
puts $fh2 [format "%-14s%-14s%s" "------------" "-------" "-------"]

foreach item $sorted_runs {
    set r_num [lindex $item 0]
    set r_avg [lindex $item 1]
    set r_max [lindex $item 2]
    puts $fh2 [format "%-14s%-14s%s" $r_num $r_avg $r_max]
}
close $fh2
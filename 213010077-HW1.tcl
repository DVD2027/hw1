set name "Shlomzion Tzur Wallach"
set TZ  "213010077"
set name2 "Rotem Markovits"
set TZ2  "330868779"
expr { srand($TZ) }

# part1

set fname1 "213010077.part1"
set fh [open $fname1 w]

puts $fh "# EX_1 $name $TZ $name2 $TZ2"

set N [expr { int(rand() * 11) + 10 }]

puts $fh "Number of runs: N = $N"

set i 1

while { $i <= $N } { 
    set M [expr {int(rand()*26+5)}]
    puts $fh "Run Number: $i"
    puts $fh "-------------"
    puts $fh "M = $M"
    set f 0
    set sum 0
    while {$f < $M} {
        set val [expr { int(rand() * ($TZ + 1)) }]
        puts $fh $val
        set sum [expr { $sum + $val }]

        incr f
    }
    set avg [format "%.1f" [expr { double($sum) / $M }]]
    puts $fh "Average = $avg\n"

    incr i }

close $fh





# part2

set fname1 "213010077.part1"
set fname2 "213010077.part2"

set fh_in [open $fname1 r]

set runs_data {}
set header_line ""
set current_run 0
set max_val -1

while { [gets $fh_in line] >= 0 } {
    
    if { [regexp {^# EX_1} $line] } {
        set header_line $line
        
    } elseif { [regexp {^Run Number:\s+(\d+)} $line match run_num] } {
        set current_run $run_num
        set max_val -1
        
    } elseif { [regexp {^\d+$} $line] } {
        if { $line > $max_val } {
            set max_val $line
        }

    } elseif { [regexp {^Average = ([0-9.]+)} $line match avg_val] } {
        lappend runs_data [list $current_run $avg_val $max_val]
    }
}

close $fh_in

set sorted_runs [lsort -real -increasing -index 1 $runs_data]

set fh_out [open $fname2 w]

puts $fh_out $header_line
puts $fh_out [format "%-14s%-14s%s" "Run Number" "Average" "Maximum"]
puts $fh_out [format "%-14s%-14s%s" "------------" "-------" "-------"]

foreach run $sorted_runs {
    set r_num [lindex $run 0]
    set r_avg [lindex $run 1]
    set r_max [lindex $run 2]
    puts $fh_out [format "%-14s%-14s%s" $r_num $r_avg $r_max]
}

close $fh_out


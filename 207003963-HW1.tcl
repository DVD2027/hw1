set IDrachel 207003963
set IDofry 209329069
set team_info "# EX_1 Rachel Malachi $IDrachel Ofry Gur $IDofry"
set part1_filename "${IDrachel}.part1"
set part2_filename "${IDrachel}.part2"

expr { srand(${IDrachel}) } ;#seed generator
#peocedure function for a random number in range
proc generate_rand { from to } {
    return [expr { $from+int(rand()*(1+$to-$from)) }]
}
#part B1 - generate N loops of calculation of avg for M random nums
set fhB1 [open "${IDrachel}.part1" w]
puts $fhB1 "$team_info"
set N [generate_rand 10 20]
puts $fhB1 "Number of runs: N = $N"
for {set run 1} {$run <= $N} {incr run} {
    set M [generate_rand 5 30]
    puts $fhB1 "Run Number: $run"
    puts $fhB1 "-------------"
    puts $fhB1 "M = $M"
    set sum 0.0
    #generate M nums - random btwn 0 and ID
    for {set i 0} {$i < $M} {incr i} {
        set val [expr { int(rand()*($IDrachel+1)) }]
        set sum [expr { $sum+$val }]
        puts $fhB1 $val
    }
    set avg [expr { $sum/double($M) }]
    puts $fhB1 [format "Average = %.1f" $avg]
    # Print space line btwn runs, except last run
    if {$run < $N} {
        puts $fhB1 ""
    }
}
close $fhB1

#part B2 - order the avgs in reading file1 and write to file2
#B2.1 - take data about runs
set fhB2r [open "${IDrachel}.part1" r]
set runs_data {}
set current_run ""
set current_max -1
set current_avg ""

#going line by line with regexp to match data type run/avg/num-update max
while {[gets $fhB2r line] >= 0} {
    if {[regexp {^Run Number:\s*(\d+)} $line match r_num]} {
        set current_run $r_num
        set current_max -1 
    } elseif {[regexp {^Average\s*=\s*([\d\.]+)} $line match avg_val]} {
        set current_avg [format "%.1f" $avg_val]
        lappend runs_data [list $current_run $current_avg $current_max]
        #it's a sign we finished going through run
    } elseif {[string is integer -strict $line]} {
        if {$current_max == -1 || $line > $current_max} {
            set current_max $line
        }
    }
}
close $fhB2r

# Sort runs by Average (run,avg,max - avg in idx 1)
set sorted_runs [lsort -real -index 1 $runs_data]

#part B2.2 write the sorted file
set fhB2w [open "${IDrachel}.part2" w]
puts $fhB2w "$team_info"
puts $fhB2w "Run Number    Average       Maximum"
puts $fhB2w "------------  -------       -------"
#ask teacher if padding of column needed or nah
foreach run_info $sorted_runs {
    lassign $run_info r_num r_avg r_max
    puts $fhB2w [format "%-14s%-14s%s" $r_num $r_avg $r_max]
}
close $fhB2w
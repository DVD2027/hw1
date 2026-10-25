# Part 1

set filename1 "327888640.part1"
set fileId [open $filename1 w]

expr { srand(327888640) }

puts $fileId "# EX_1 Gil Rozen 327888640"

set N [expr {int(rand() * 11) + 10}]
puts $fileId "Number of runs: N = $N"

for { set i 1 } { $i <= $N } { incr i } {
    puts $fileId "Run Number: $i"
    puts $fileId "-------------"
    
    set M [expr {int(rand() * 26) + 5}]
    puts $fileId "M = $M"
    
    set sum 0
    
    for { set j 0 } { $j < $M } { incr j } {
        set R [expr {int(rand() * 327888641)}]
        puts $fileId $R
        set sum [expr {$sum + $R}]
    }
    
    set avr [expr {double($sum) / $M}]
    puts $fileId "Average = [format "%.1f" $avr]"
    
    if { $i < $N } {
        puts $fileId ""
    }
}

close $fileId



# Part 2

set filename2 "327888640.part2"
set file1 [open $filename1 r]

set all_runs {}
set current_run ""
set current_max -1
set current_avg ""

while { [gets $file1 line] >= 0 } {
    if { [string match "Run Number: *" $line] } {
        set current_run [lindex $line 2]
        set current_max -1
        
    } elseif { [string is integer -strict $line] } {
        if { $line > $current_max } {
            set current_max $line
        }
        
    } elseif { [string match "Average = *" $line] } {
        set current_avg [lindex $line 2]
        lappend all_runs [list $current_run $current_avg $current_max]
    }
}
close $file1

set sorted_runs [lsort -real -index 1 $all_runs]

set file2 [open $filename2 w]

puts $file2 "# EX_1 Gil Rozen 327888640"
puts $file2 [format "%-14s%-14s%s" "Run Number" "Average" "Maximum"]
puts $file2 [format "%-14s%-14s%s" "------------" "-------" "-------"]

foreach run_data $sorted_runs {
    lassign $run_data run avg max
    puts $file2 [format "%-14s%-14s%s" $run $avg $max]
}

close $file2
# HW1 - Digital VLSI Design
# Tcl script


# Initialize random seed
set ID 314778333
expr {srand($ID)}

# Generate number of runs
set N [expr {int(rand() * 11) + 10}]

set filename "$ID.part1"
set fh [open $filename w]

# Write header
puts $fh "# EX_1 May Menaged 314778333 Elishama Seri 324232560"
puts $fh "Number of runs: N = $N"


# Generate M for each run
for {set i 1} {$i <= $N} {incr i} {
    set M [expr {int(rand() * 26) + 5}]
    puts $fh "Run Number: $i"
    puts $fh "-------------"
    puts $fh "M = $M"

    set sum 0

   for {set j 1} {$j <= $M} {incr j} {
     set num [expr {int(rand() * ($ID + 1))}]
     set sum [expr {$sum + $num}]
     puts $fh $num
    }
    # Calculate average for this run
    set average [expr {double($sum) / $M}]
    puts $fh [format "Average = %.1f" $average]
    puts $fh ""
}

close $fh

# Part 2 - Read and analyze Part 1 output

set fh [open $filename r]
set results {}

while {[gets $fh line] >= 0} {

    if {[string match "Run Number: *" $line]} {
        set run_id [lindex $line end]
        set max_num -1
    }

    if {[string is integer -strict $line]} {
      if {$line > $max_num} {
          set max_num $line
        }
    }   

    if {[string match "Average = *" $line]} {
        set avg [lindex $line end]
        lappend results [list $run_id $avg $max_num]
    }


}
close $fh

set sorted_results [lsort -real -index 1 $results]
set output_file "$ID.part2"
set out [open $output_file w]

puts $out "# EX_1 May Menaged 314778333 Elishama Seri 324232560"
puts $out "Run Number    Average       Maximum"
puts $out "------------  -------       -------"
foreach result $sorted_results {
    lassign $result run_id avg max_num
    puts $out [format "%-14s%-14s%s" $run_id $avg $max_num]
}

close $out





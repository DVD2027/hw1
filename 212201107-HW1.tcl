set ID_num 212201107
expr {srand($ID_num)}
set N [expr {int(rand() * 11) + 10}]

set fh [open "${ID_num}.part1" w]

puts $fh "\# EX_1 Hallel Meir 212201107 Neta Morad 212617740"
 
puts $fh "Number of runs: N = $N"

set i 1
while {$i <= $N} {

puts $fh "Run Number: $i"
puts $fh "-------------"
set M [expr {int(rand() * 26) + 5}]
puts $fh "M = $M"
set sum 0

for {set j 1} {$j <= $M} {incr j} {
set temp [expr {int(rand() * ($ID_num + 1))}]
set sum [expr $sum + $temp]
puts $fh $temp
}

set average [expr $sum/double($M)]
puts $fh [format "Average = %.1f" $average];
puts $fh ""

incr i
}

close $fh

set fh [open "${ID_num}.part1" r]

set runs {}
set current_max -1
set current_run ""
set header ""


while { [gets $fh line] >= 0 } {


    if { [string match "# EX_1*" $line] } { 

        set header $line
    

   } elseif { [regexp {Run Number:\s*([0-9]+)} $line match run_num] } {
     
        set current_run $run_num
        set current_max -1 

   
   } elseif { [regexp {Average\s*=\s*([0-9.]+)} $line match avg] } {

        set run [list $current_run $avg $current_max]
        lappend runs $run

   

   } elseif { [regexp {^([0-9]+)$} $line match val] } {

        if { $val > $current_max } {set current_max $val} }
    }
       
       


close $fh


set fh [open "${ID_num}.part2" w]

set sorted_runs [lsort -real -index 1 $runs]


puts $fh $header
puts $fh [format "%-14s%-14s%s" "Run Number" "Average" "Maximum"]
puts $fh [format "%-14s%-14s%s" "------------" "-------" "-------"]


foreach run $sorted_runs {

set run_num [lindex $run 0]
set avg [lindex $run 1]
set max [lindex $run 2]

puts $fh [format "%-14s%-14s%s" $run_num $avg $max] 
}


close $fh



#first part, (also known as part B.1)
# <------------------------------------->
set id 325541514
set fp1 [open "$id.part1" w]     ;# opening the file for writing (delite previos file).
expr { srand($id) }               ;# seed the pseudo-random generator with my id.
set N [expr {int(rand()*11+10)}]          ;# chosing the random number to repet the prosess.
#
#
#
puts $fp1 "# EX_1 Emily Benyaminov 325541514"
puts $fp1 "# EX_1 Shevah Cohen 330667064"

puts $fp1 "Number of runs: N = $N"

set i 0
while {$i <$N}  {
    puts $fp1 "Run Number: [expr $i+1]"
    puts $fp1 "---------------"
    set M [expr {int(rand()*26+5)}]          ;# chosing a random number to compute the average.
    set j 0
    set sum 0
    puts $fp1 "M = $M"
    while {$j <$M}  {
        set val [expr { int(rand() * ($id + 1)) }]
        puts $fp1 $val
        set sum [expr { $sum + $val }]
        incr j
    }
    set average [expr {double($sum)/$M}]
    puts $fp1 "Average = [format "%.1f" $average]"
    incr i
}
close $fp1
#end of the first part
# <------------------------------------->
#****************************************
#****************************************
#****************************************
#second part, (also known as part B.2)
# <------------------------------------->
set fp1 [open "$id.part1" r]
set fp2 [open "$id.part2" w]
set max_num -1
while { [gets $fp1 line] >= 0 } { 
    regexp {Number of runs:\s+N\s+=\s+(\d+)} $line match new_N
    regexp {Run Number:\s+(\d+)} $line match run_num
if {[string is integer -strict [string trim $line]]} {
        set number [string trim $line]
        if {$max_num == -1 || $number > $max_num} {
            set max_num $number
        }
    }
    if {[regexp {Average\s+=\s+([0-9\.]+)} $line match avg]} {
        set max_list($run_num) "$max_num"
        set avg_list($avg) "$run_num"
        set max_num -1
    }
}
puts $fp2 "# EX_1 Emily Benyaminov 325541514"
puts $fp2 "# EX_1 Shevah Cohen 330667064"
puts $fp2 [format "%-15s%-15s%s" "Run Number" "Average" "Maximum"]
puts $fp2 [format "%-15s%-15s%s" "------------" "-------" "-------"]
foreach avg_num [lsort -real [array names avg_list]] {
    set run_num $avg_list($avg_num)
    set formatted_avg [format "%.1f" $avg_num]
    puts $fp2 [format "%-15s%-15s%s" $run_num $formatted_avg $max_list($run_num)]
}
close $fp1
close $fp2


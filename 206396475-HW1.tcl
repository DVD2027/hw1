set part1 [open "206396475.part1" w]
puts $part1 "# EX_1 Ofir Adler 206396475 Adi Kastenovich 325710192"
expr { srand(206396475) }
set N [expr {int(rand()*11)} + 10]
puts $part1 "Number of runs: N = $N"
for { set i 0 } { $i < $N } { incr i } {
    puts $part1 "Run Number: [expr $i+1]"
    puts $part1 "-------------"
    set M [expr {int(rand()*26)} + 5]
    puts $part1 "M = $M"
    set sum 0
    for { set j 0 } { $j < $M } { incr j } {
        set current [expr {int(rand()*(206396475+1))}]
        puts $part1 $current
        incr sum $current
    }
    puts $part1 "Average = [format {%0.1f} [expr double($sum)/$M]]\n"
}
close $part1

set part1 [open "206396475.part1" r]
set part2 [open "206396475.part2" w]

set mainList {}
while {[gets $part1 line] >=0} {
    if {[regexp {Run Number: (.*)} $line match run_n]} {
        set max 0
        gets $part1 line
        gets $part1 line
        gets $part1 line
        while {[string is integer $line]} {
            if {$max < $line} {
                set max $line
            }
            gets $part1 line
        }
        regexp {Average = (.*)} $line match avg
        lappend mainList "$run_n $avg $max"
    }
}
set mainList [lsort -real -index 1 $mainList]

puts $part2 "# EX_1 Ofir Adler 206396475 Adi Kastenovich 325710192"
puts $part2 [format {%-14s%-14s%s} "Run Number" "Average" "Maximum"]
puts $part2 [format {%-14s%-14s%s} "------------" "-------" "-------"]
foreach lil_list $mainList {
    puts $part2 [format {%-14s%-14s%s} {*}$lil_list]
}
close $part1
close $part2
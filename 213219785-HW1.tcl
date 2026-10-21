#Eviatar Barak 322997073 && Yehuda Bar Zakay 213219785

#seed the srand with my ID
expr {srand(213219785)}     ;#seed the rand()


#first file:
set fh1 [open "213219785.part1" w]     ;#open the first file

puts $fh1 "# EX_1 Eviatar Barak 322997073 Yehuda Bar Zakay 213219785"

#N - number of loops
set N [expr {10+int(rand()*11)}]    ;#N is 10-20
puts $fh1 "Number of runs: N = $N"

for {set i 1} {$i<=$N} {incr i} {
    puts $fh1 "Run number: $i\n-------------"

   
    set sum 0       ;#cleared each iteration for its own avg
    set M [expr {5+int(rand()*26)}]    ;#M is 5-30
    puts $fh1 "M = $M"

    for {set j 0} {$j<$M} {incr j} {
        set numRand [expr {int(rand()*213219785)}]    ;#randon numbers 0-ID (inclusive)
        puts $fh1 $numRand
        set sum [expr {$sum+$numRand}]      ;#update sum
    }

    set avg [expr {double($sum)/$M}]        ;#clac avg
    puts $fh1 "Average = [format {%.1f} $avg]\n"     ;#keep 1 decimal value
}

#close 1st file
close $fh1


#second file:
set fh1 [open "213219785.part1" r]     ;#open the first file for reading

# array[N] for the N avgs, each cell is vector of 3: Run Number, Average, Maximum
set table {}


while { [gets $fh1 line] >= 0 } { ;# read line by line
    set vec {}
    if {[regexp {^Run number: (\d+)} $line -> run_num]} {
        lappend vec $run_num
        gets $fh1;       ;#skip 1 line
        gets $fh1 line
        regexp {^M = (\d+)} $line -> MTemp

        set maxTemp 0
        #go through all the numbers, until you reach a text - and get the max
        for {set j 0} {$j<$MTemp} {incr j} {
            gets $fh1 line
            regexp {(\d+)} $line -> numTemp
            if {$numTemp > $maxTemp} {set maxTemp $numTemp}
        }

        gets $fh1 line
        if {[regexp {Average\s*=\s*(\S+)} $line -> avgTemp]} {
            lappend vec $avgTemp
        }
        lappend vec $maxTemp

        lappend table $vec
    }
} ;#end while

close $fh1


set fh2 [open "213219785.part2" w]     ;#open the second file for writing

puts $fh2 "# EX_1 Eviatar Barak 322997073 Yehuda Bar Zakay 213219785"

puts $fh2 "Run Number    Average       Maximum"
puts $fh2 "------------  -------       -------"

set sortedByAvg [lsort -real -index 1 $table]   ;# sort the table by the index 1 (second), a real number (float)

foreach vecFor $sortedByAvg {
    puts $fh2 [format {%-14s%-14s%s} [lindex $vecFor 0] [lindex $vecFor 1] [lindex $vecFor 2]]
}
#Eviatar Barak 322997073 && Yehuda Bar Zakay 213219785

#seed the srand with my ID
expr {srand(213219785)} 

#writing first file:
set fh1 [open "213219785.part1" w]     ;#open the first file
puts $fh1 "# EX_1 Eviatar Barak 322997073 Yehuda Bar Zakay 213219785"

#N - number of loops
set N [expr {10+int(rand()*11)}]    ;#N is 10-20
puts $fh1 "Number of runs: N = $N"

for {set i 1} {$i<=$N} {incr i} {       ;#i for 1 to N including, so i is exactly the run number
    puts $fh1 "Run Number: $i\n-------------"

    set sum 0       ;#cleared each iteration for its own avg
    set M [expr {5+int(rand()*26)}]    ;#M is 5-30
    puts $fh1 "M = $M"

    for {set j 0} {$j<$M} {incr j} {
        set numRand [expr {int(rand()*213219786)}]    ;#random numbers 0-ID (inclusive)
        puts $fh1 $numRand
        set sum [expr {$sum+$numRand}]      ;#update sum
    }

    set avg [expr {double($sum)/$M}]        ;#clac avg
    puts $fh1 "Average = [format {%.1f} $avg]"     ;#keep 1 decimal value

    if {$i<$N} {puts $fh1 ""}
}

close $fh1

#reading 1st file
set fh1 [open "213219785.part1" r]     ;#open the first file for reading

# array[N][3] for the N runs, each cell is vector of 3: Run Number, Average, Maximum
set table {}

while { [gets $fh1 line] >= 0 } { ;# read line by line
    set vec {}
    if {[regexp {^Run Number: (\d+)} $line -> run_num]} {
        lappend vec $run_num        ;#vec[0] is run-number
        gets $fh1;       ;#skip 1 line - the dashes
        gets $fh1 line
        regexp {^M = (\d+)} $line -> MTemp      ;#get number of values

        set maxTemp 0
        #go through all the numbers, and get the max
        for {set j 0} {$j<$MTemp} {incr j} {
            gets $fh1 line
            regexp {(\d+)} $line -> numTemp
            if {$numTemp > $maxTemp} {set maxTemp $numTemp}
        }

        gets $fh1 line
        if {[regexp {Average\s*=\s*(\S+)} $line -> avgTemp]} {
            lappend vec $avgTemp    ;#vec[1] is avg
        }
        lappend vec $maxTemp        ;#vec[2] is max

        lappend table $vec
    }
} ;#end while

close $fh1

#writing 2nd file
set fh2 [open "213219785.part2" w]     ;#open the second file for writing

puts $fh2 "# EX_1 Eviatar Barak 322997073 Yehuda Bar Zakay 213219785"

puts $fh2 "Run Number    Average       Maximum"
puts $fh2 "------------  -------       -------"

set sortedByAvg [lsort -real -index 1 $table]   ;# sort the table by the index 1 (second), a real number (float)

#go through all the vectors and print them in 14p format
foreach vecFor $sortedByAvg {
    puts $fh2 [format {%-14s%-14s%s} [lindex $vecFor 0] [lindex $vecFor 1] [lindex $vecFor 2]]
}

close $fh2
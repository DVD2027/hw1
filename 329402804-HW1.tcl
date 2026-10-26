#Joseph Yehezkel 216848838
#Itay Aharon 329402804

expr { srand(329402804) }; #seeding the pseudo random number generator


#PART 1


#getting random N
set T [ expr ( int(rand()*11) )]; #defining t to be a random number 0-10 
set N [ expr ( $T + 10 ) ]; # +10 (so 10-20);

#file handler stuff
set fhOutput1 [ open 329402804.part1 w ]; #opening file for write

#names and IDs
puts $fhOutput1 "# EX_1 Joseph Yehezkel 329402804";
puts $fhOutput1 "# EX_1 Itay Aharon 329402804";

#Output file 1 header
puts $fhOutput1 [format "Number of runs: N = %d" $N];

#outer loop
for { set j 0 } { $j < $N } { incr j } {

    #start of loop text
    puts $fhOutput1 [format "Run number: %d" [expr ( $j +1 )]]
    puts $fhOutput1 "-------------"

    #getting random M
    set T [ expr ( int(rand()*26) )] ; #defining t to be a random number 0-25 
    set M [ expr ( $T + 5 ) ]; # +5 (so 5-30);
    puts $fhOutput1 [format "M = %d" $M];

    #setup before the inner loop
    set Sum 0;

    #loop for getting run's average
    for { set i 0 } { $i < $M } { incr i } { 
        set T [ expr ( int(rand()*329402804) )]; #getting a random number
        puts $fhOutput1 $T;
        set Sum [ expr ( $Sum + $T)];
    }
    set Avg [expr ( double( $Sum )/$M )]
    puts $fhOutput1 [format "Average = %0.1f" $Avg]

    puts $fhOutput1 ""
}

close $fhOutput1


#PART 2:


set fhRead [ open 329402804.part1 r ]; #opening file for read
set fhOutput2 [ open 329402804.part2 w ]; #opening second file for write

#names and IDs
puts $fhOutput2 "# EX_1 Joseph Yehezkel 216848838";
puts $fhOutput2 "# EX_1 Itay Aharon 329402804";

#skipping the first 2 lines because they're names and IDs
gets $fhRead line
gets $fhRead line

#getting N from file
gets $fhRead ReadN

set readN [ string range $ReadN 20 end ]

#start of file stuff
puts $fhOutput2 [format {%-14s%-14s%s} "Run Number" "Average" "Maximum"]
puts $fhOutput2 [format {%-14s%-14s%s} "------------" "-------" "-------"]

#creating 2 lists
set maxList { }; #List that holds the maximum value of each run
set avgList { }; #List that holds the average of each run

#looping through runs by N
for { set i 0 } { $i < $readN } { incr i } {
    #we need to skip the run number and --- lines
    gets $fhRead
    gets $fhRead

    #each run, we will put all the values in a list and sort and take the highest one (run's maximum)
    set tempList { }; #empty list to which we will append values
    #getting run's M
    gets $fhRead readM
    set readM [ string range $readM 4 end]
    for { set j 0 } { $j < $readM } { incr j } {
        gets $fhRead val
        lappend tempList $val
    }

    lappend maxList [lindex [lsort -integer $tempList] end]

    #getting the run's average
    gets $fhRead runAvg
    lappend avgList [ string range $runAvg 10 end]

    #at the end of the reading, we need to read a line to get to the same point for the next run in the next iteration
    gets $fhRead
}

#foreach ele $maxList { puts $fhOutput2 $ele }
#puts $fhOutput2 ""
#foreach ele $avgList { puts $fhOutput2 $ele }

set avgMaxPairs { }; #a list of pairs of averages and maxes and index so we can sort both according to the average as well as keep track of the run number
for { set i 0 } { $i < $readN } { incr i } { 
    lappend avgMaxPairs [ list [expr $i +1] [lindex $avgList $i] [lindex $maxList $i] ]
}

set avgMaxPairs [lsort -real -index 1 $avgMaxPairs]; #sorting the list
foreach ele $avgMaxPairs { puts $fhOutput2 [format {%-14s%-14s%s} [lindex $ele 0] [lindex $ele 1] [lindex $ele 2]] }

close $fhRead
close $fhOutput2
set rep_id 207810912
set student2_id 322807983

expr { srand($rep_id) }
set N [expr {int(rand()*11) + 10}]

# Process that helps generating multiple randoms based on seed
proc generate_randoms {m} {
    global rep_id ;# Fixed the typo here (added the 'p')

    set result {}
    for {set i 0} {$i < $m} {incr i} {
        set rand_val [expr {int(rand() * ($rep_id + 1))}]
        lappend result $rand_val
    }
    return $result
}

#-----------------------------------------------------------------------------------------------
# PART 1: N runs of randomizing M, generating and calulating avg

set fh [open "${rep_id}.part1" w]     ;# clean file

puts $fh "# EX_1 Almog Bitan $rep_id Yoav Megidish $student2_id" ;# Assuming title via example
puts $fh "Number of runs: N = $N"

for {set i 0} {$i < $N} {incr i} {    
    puts $fh "Run Number: [expr {$i + 1}]"
    puts $fh "-------------"

    set M [expr {int(rand()*26) + 5}] ;# set M 5 + (0...25) = 5...30
    set m_rands [generate_randoms $M] ;# Generate exactly M randoms

    set sum 0

    puts $fh "M = $M"
    
    # Calculate sum and write individual numbers line-by-line
    foreach val $m_rands {
        puts $fh $val
        set sum [expr {$sum + $val}]
    }

    set avg [expr {double($sum) / $M}]
    
    # Write the average line and an empty line for spacing
    puts $fh "Average = [format %.1f $avg]"
    puts $fh ""
}

# Close the part1 file
close $fh

# PART 1: END
#-----------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------
# PART 2: read .part1 file and analize

# triplets_list will be used to contain sets of run_num, run_avg, run_max

# START READING .part1 FILE
 
set triplets_list {}
set fh [open "${rep_id}.part1" r]     ;# open for reading

set cur_run ""
set cur_avg ""
set cur_max -1 ;# Track maximum internally as we read raw numbers

while {[gets $fh line] >= 0} {
    # Clean up whitespaces
    # set line [string trim $line]

    # Ignore comments, empty lines, or the M count line
    if {$line eq "" || [string match "#*" $line] || [string match "M = *" $line] || [string match "---*" $line]} {
        continue
    }

    # HANDLE NEW RUN
    if {[string match "Run Number: *" $line]} {
        set cur_run [string range $line 12 end]
        set cur_max -1 ;# Reset the maximum tracker for this brand new run
    
    # HANDLE AVG OF CURRENT RUN
    } elseif {[string match "Average = *" $line]} {
        set cur_avg [string range $line 10 end]
        
        # We reached the end of the run block! Save the triplet
        set triplet [list $cur_run $cur_avg $cur_max]
        lappend triplets_list $triplet
    
    # HANDLE RAW RANDOM, CHACK FOR MAX
    } elseif {[string is integer -strict $line]} {
        # This must be one of the raw random numbers!
        if {$line > $cur_max} {
            set cur_max $line
        }
    }
}

close $fh

# END READING .part1 FILE

# START WRITING ,part2 FILE

# Sort the triplets array by average using built in lsort
set triplets_list [lsort -real -index 1 $triplets_list]

set fh [open "${rep_id}.part2" w]

puts $fh "# EX_1 Almog Bitan $rep_id Yoav Megidish $student2_id" ;# Assuming title via example
puts $fh "Run Number    Average       Maximum" ;# using spacing from example
puts $fh "------------  -------       -------"

# Input properly formatted line by line
foreach val $triplets_list {
    puts $fh [format "%-14s%-14s%s" \
        [lindex $val 0] [lindex $val 1] [lindex $val 2]]
}
# END READING .part2 FILE

# PART2: END
#-----------------------------------------------------------------------------------------------

# HW1 - Tcl

set representative_name "Ori Arie"
set representative_id 328462536
set partner_name "Shaul Matz"
set partner_id 322805383

set header "# EX_1 $representative_name $representative_id $partner_name $partner_id"
set part1_file "$representative_id.part1"
set part2_file "$representative_id.part2"

# Seed the pseudo-random generator with the representative ID.
expr {srand($representative_id)}

# ---------------- Part 1 ----------------

# N is a random integer in the inclusive range 10..20.
set N [expr {int(rand() * 11) + 10}]

set out1 [open $part1_file w]
puts $out1 $header
puts $out1 "Number of runs: N = $N"

for {set run 1} {$run <= $N} {incr run} {
    # M is a random integer in the inclusive range 5..30.
    set M [expr {int(rand() * 26) + 5}]

    puts $out1 "Run Number: $run"
    puts $out1 "-------------"
    puts $out1 "M = $M"

    set sum 0
    for {set i 0} {$i < $M} {incr i} {
        # Random value in the inclusive range 0..representative_id.
        set value [expr {int(rand() * ($representative_id + 1))}]
        puts $out1 $value
        set sum [expr {$sum + $value}]
    }

    # Force floating-point division, as required by the sample format.
    set average [format "%.1f" [expr {double($sum) / $M}]]
    puts $out1 "Average = $average"
    puts $out1 ""
}

close $out1

# ---------------- Part 2 ----------------

# Parse the .part1 file from disk; do not reuse Part 1 in-memory values.
# Open the Part 1 output file in read mode.
set in1 [open $part1_file r]
set runs {}
set current_run ""
set current_max ""

# Read the input file line by line until the end of the file.
while {[gets $in1 line] >= 0} {
    # Check if the line starts a new run and extract its run number.
    # ^-start of line, [0-9]+-one or more digits, $-end of line (...)- stored in run_number 
    if {[regexp {^Run Number: ([0-9]+)$} $line not_needed run_number]} {
        set current_run $run_number
        set current_max ""
    } elseif {[regexp {^[0-9]+$} $line]} {
        set number $line
        if {$current_max eq "" || $number > $current_max} {
            set current_max $number
        }
    } elseif {[regexp {^Average = (.+)$} $line not_needed average]} {
        lappend runs [list $average $current_run $current_max]
    }
}

close $in1

# Sort the runs in ascending numerical order by their averages (index 0).
#-real:sorts numerically as real numbers -index0: sort according to first member of each sublist
set runs [lsort -real -index 0 $runs]

set out2 [open $part2_file w]
puts $out2 $header
puts $out2 [format "%-14s%-14s%s" "Run Number" "Average" "Maximum"]
puts $out2 [format "%-14s%-14s%s" "------------" "-------" "-------"]
 
foreach run_data $runs {
# lindex - returns the element of a list at the specified index.
    set average [lindex $run_data 0]
    set run_number [lindex $run_data 1]
    set maximum [lindex $run_data 2]
    puts $out2 [format "%-14s%-14s%s" $run_number $average $maximum]
}

close $out2

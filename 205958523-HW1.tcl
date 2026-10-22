# =============================================================================
# B.1 Part 1: Generate random values and calculate each run's average.
# =============================================================================

set studentname "Ben Moran"
set studentid "205958523"

set student2name "Eliel Hadad"
set student2id "212998371"

set bothstudents "$studentname $studentid $student2name $student2id"

expr { srand($studentid) }

set filename "${studentid}.part1"
set file [open $filename "w"]

# Write the identifying header and choose how many runs to generate.
puts $file "# EX_1 $bothstudents"

set N [expr {int(rand() * 11) + 10}]

puts $file "Number of runs: N = $N"

for {set i 1} {$i <= $N} {incr i} {
    puts $file "Run number: $i"
    puts $file "-------------------"

    # Choose the number of values in this run.
    set M [expr {int(rand() * 6) + 25}]

    puts $file "M = $M"

    set sum 0

    for {set j 0} {$j < $M} {incr j} {
        # Generate a value, write it, and add it to the running total.
        set val [expr {int(rand() * ($studentid + 1))}]

        puts $file $val

        set sum [expr {$sum + $val}]
    }

    # Format the mean to two decimal places before writing it.
    set average [format {%0.2f} [expr {double($sum) / $M}]]
    puts $file "Average = $average"
    puts $file ""
}

close $file



# =============================================================================
# B.2 Part 2: Parse the generated file and report each run's statistics.
# =============================================================================

set input_file_name "${studentid}.part1"
set output_file_name "${studentid}.part2"

set input_file [open $input_file_name "r"]

set header_line ""
set runs [list]
set current_run_number ""
set in_run_section 0
set current_average ""

while {[gets $input_file line] >= 0} {
    # Normalize whitespace before checking the line's format.
    set trimmed [string trim $line]

    # Save the header once so it can be copied into the results file.
    if {[string match "#*" $trimmed] && $header_line eq ""} {
        set header_line $trimmed
        continue
    }

    # Start tracking a new run and reset its maximum.
    if {[regexp {^Run number:\s*(\d+)} $trimmed -> r_num]} {
        set current_run_number $r_num
        set current_max ""
        set in_run_section 0
        continue
    }

    # The divider marks the beginning of the run's values.
    if {[regexp {^-+$} $trimmed]} {
        set in_run_section 1
        continue
    }

    # Skip the value-count line; it is not part of the run's data.
    if {[regexp {^M\s*= } $trimmed]} {
        continue
    }

    # Update the maximum while the parser is inside a run's values.
    if {$in_run_section && [string is integer $trimmed]} {
        set val [expr {int($trimmed)}]
        if {$current_max eq "" || $val > $current_max} {
            set current_max $val
        }

        continue
    }

    # The average ends the run; retain its summary fields for output.
    if {[regexp {^Average\s*=\s*([0-9.]+)} $trimmed -> current_average]} {
        lappend runs [list $current_run_number $current_average $current_max]

        set in_run_section 0
        continue
    }
}

close $input_file

# Sort the summaries by average in ascending order.
set sorted_runs [lsort -index 1 -real $runs]

set out_file [open $output_file_name "w"]

puts $out_file $header_line
puts $out_file "Run Number    Average       Maximum"
puts $out_file "------------  -------       -------"

foreach run $sorted_runs {
    set run_number [lindex $run 0]
    set average [lindex $run 1]
    set maximum [lindex $run 2]

    # Keep the columns aligned in the output file.
    puts $out_file [format "%-12s  %-12s  %-12s" $run_number $average $maximum]
}

close $out_file
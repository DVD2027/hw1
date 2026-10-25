# HW1 - Tcl: random-number report and file analysis
set representative_name "Rivka Maman"
set representative_id "212849103"
set partner_name "Elad Toledano"
set partner_id "212105852"

if {![string is integer -strict $representative_id] ||
    ![string is integer -strict $partner_id] ||
    $representative_name eq "YOUR_FIRST_AND_LAST_NAME" ||
    $partner_name eq "PARTNER_FIRST_AND_LAST_NAME"} {
    error "Fill in both partners' names and IDs before running."
}

set heading "# EX_1 $representative_name $representative_id $partner_name $partner_id"
set first_file "${representative_id}.part1"
set second_file "${representative_id}.part2"

# PART 1 - Produce a report. The representative's ID determines the RNG seed.
expr {srand($representative_id)}
set run_count [expr {10 + int(rand() * 11)}]
set output [open $first_file w]
puts $output $heading
puts $output "Number of runs: N = $run_count"

for {set run 1} {$run <= $run_count} {incr run} {
    puts $output "Run Number: $run"
    puts $output "-------------"

    set number_count [expr {5 + int(rand() * 26)}]
    puts $output "M = $number_count"
    set total 0
    for {set j 0} {$j < $number_count} {incr j} {
        set value [expr {int(rand() * ($representative_id + 1))}]
        puts $output $value
        incr total $value
    }
    set mean [expr {double($total) / $number_count}]
    puts $output "Average = [format %.1f $mean]"
    if {$run < $run_count} {puts $output ""}
}
close $output

# PART 2 - Recover the data solely from the report file (not Part 1 variables).
set input [open $first_file r]
set observations {}
set current_run ""
set expected_count -1
set seen_count 0
set largest -1

while {[gets $input line] >= 0} {
    set line [string trim $line]
    if {[regexp {^Run Number: ([0-9]+)$} $line -> run_number]} {
        set current_run $run_number
        set expected_count -1
        set seen_count 0
        set largest -1
    } elseif {[regexp {^M = ([0-9]+)$} $line -> count]} {
        set expected_count $count
    } elseif {[regexp {^([0-9]+)$} $line -> value]} {
        if {$current_run ne "" && $expected_count >= 0} {
            incr seen_count
            if {$value > $largest} {set largest $value}
        }
    } elseif {[regexp {^Average = ([0-9]+(?:\.[0-9]+)?)$} $line -> average]} {
        if {$current_run eq "" || $seen_count != $expected_count} {
            close $input
            error "Unexpected content in $first_file near: $line"
        }
        lappend observations [list $current_run $average $largest]
        set current_run ""
    }
}
close $input
if {[llength $observations] != $run_count} {
    error "Wrong number of parsed runs in $first_file"
}

set observations [lsort -real -index 1 $observations]
set output [open $second_file w]
puts $output $heading
puts $output "Run Number    Average       Maximum"
puts $output "------------  -------       -------"
foreach record $observations {
    lassign $record run_number average largest
    puts $output [format "%-14s%-14s%s" $run_number $average $largest]
}
close $output
puts "Created $first_file and $second_file"

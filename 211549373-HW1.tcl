# ==========================================
# Part 1: Generate runs and compute averages
# ==========================================

set my_id 211549373
set my_name "Adir Okashy"
set partner_id 215068719
set partner_name "Eitan Menasher"

# Seed the pseudo-random number generator with the representative ID
expr { srand($my_id) }

set filename_part1 "${my_id}.part1"
set fh1 [open $filename_part1 w]

# Write header line
puts $fh1 "# EX_1 $my_name $my_id $partner_name $partner_id"

# N randomized between 10 and 20
set N [expr { int(rand() * 11) + 10 }]
puts $fh1 "Number of runs: N = $N"

for { set i 1 } { $i <= $N } { incr i } {
    puts $fh1 "Run Number: $i"
    puts $fh1 "-------------"
    
    # M randomized between 5 and 30
    set M [expr { int(rand() * 26) + 5 }]
    puts $fh1 "M = $M"
    
    set sum 0
    for { set j 0 } { $j < $M } { incr j } {
        # Random integer between 0 and representative ID
        set val [expr { int(rand() * ($my_id + 1)) }]
        puts $fh1 $val
        set sum [expr { $sum + $val }]
    }
    
    # Compute average rounded to one decimal place
    set raw_avg [expr { double($sum) / $M }]
    set avg [format "%.1f" $raw_avg]
    puts $fh1 "Average = $avg"
    puts $fh1 ""
}

close $fh1
puts "Part 1 completed: $filename_part1 generated."


# ==========================================
# Part 2: Parse .part1 and create .part2
# ==========================================

set filename_part2 "${my_id}.part2"
set in_fh [open $filename_part1 r]

# Read header line from .part1
gets $in_fh header_line

set runs_data {}
set current_run 0
set current_max -1
set in_run_numbers 0

# Parse .part1 line by line
while { [gets $in_fh line] >= 0 } {
    set line [string trim $line]
    if { $line eq "" } {
        continue
    }
    
    if { [regexp {^Run Number:\s+(\d+)} $line match run_num] } {
        set current_run $run_num
        set current_max -1
        set in_run_numbers 0
    } elseif { [regexp {^M\s*=\s*\d+} $line] } {
        set in_run_numbers 1
    } elseif { [regexp {^Average\s*=\s*([0-9.]+)} $line match avg_val] } {
        set in_run_numbers 0
        lappend runs_data [list $current_run $avg_val $current_max]
    } elseif { $in_run_numbers && [string is integer -strict $line] } {
        if { $current_max == -1 || $line > $current_max } {
            set current_max $line
        }
    }
}
close $in_fh

# Sort runs by average (index 1) in ascending order
set sorted_runs [lsort -real -index 1 $runs_data]

# Write formatted output to .part2
set out_fh [open $filename_part2 w]
puts $out_fh $header_line
puts $out_fh [format "%-14s%-14s%s" "Run Number" "Average" "Maximum"]
puts $out_fh [format "%-14s%-14s%s" "------------" "-------" "-------"]

foreach item $sorted_runs {
    set r_num [lindex $item 0]
    set r_avg [lindex $item 1]
    set r_max [lindex $item 2]
    puts $out_fh [format "%-14s%-14s%s" $r_num $r_avg $r_max]
}

close $out_fh
puts "Part 2 completed: $filename_part2 generated."
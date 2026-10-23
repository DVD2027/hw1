# ===================================
# PART 1: Calculate a running average
# ===================================
expr {srand(208160473)}
set N [expr {int(rand()*11)+10}]; # Generate N in range 10-20
set part1_file "208160473.part1"
set fp1 [open $part1_file "w"]

puts $fp1 "# EX_1 Daniel Elbaz 208160473"
puts $fp1 "Number of runs: N = $N"

for {set i 1} {$i <= $N} {incr i} {
        puts $fp1 "Run Number: $i"
        puts $fp1 "---------------------"
        set M [expr {int(rand()*26)+5}]; # Generate M in range 5-30
        puts $fp1 "M = $M"
	puts $fp1 ""

        set sum 0
        for {set j 0} {$j < $M} {incr j} {
                set num_value [expr {int(rand()*208160474)}]; # Generate values in range 0-208160473
                puts $fp1 $num_value
                set sum [expr {$sum+$num_value}]
        }

        set avg [expr {double($sum)/$M}]
        puts $fp1 "Average = $avg"
        puts $fp1 ""
}

close $fp1

# =========================
# PART 2: Parse and Analyze
# =========================
set input_file "208160473.part1"
set output_file "208160473.part2"

set fp_in [open $input_file "r"]
set file_data [read $fp_in]
close $fp_in

set lines [split $file_data "\n"]

set runs [list]
set header_line ""
if {[llength $lines] > 0} {
        set header_line [lindex $lines 0]
}

set total_lines [llength $lines]
set i 2; # Skipping the 2 first lines

while {$i < $total_lines} {
        set line [string trim [lindex $lines $i]]
        if {$line eq ""} {
                incr i
                continue
        }

        if {[string match "Run Number: *" $line]} {
                set run_num [lindex [split $line ":"] 1]
                set run_num [string trim $run_num]
                incr i 2; # Skipping "---.." line
                # Reading M value
                set m_line [string trim [lindex $lines $i]]
                set m_val [lindex [split $m_line "="] 1]
                set m_val [string trim $m_val]

                incr i
                set max_val -1

                # Find the max number
                for {set j 0} {$j < $m_val} {incr j} {
                        set num_str [string trim [lindex $lines $i]]
                        if {![string match "Average = *" $num_str]} {
                                if {$max_val == -1 || $num_str > $max_val} {
                                        set max_val $num_str
                                }
                        }
                        incr i
                }

                # Get the Average
                set avg_line [string trim [lindex $lines $i]]
                while {$i < $total_lines && ![string match "Average = *" $avg_line]} {
			incr i
			set avg_line [string trim [lindex $lines $i]]
		}
		set avg_val [lindex [split $avg_line "="] 1]
                set avg_val [string trim $avg_val]

                lappend runs [list $run_num $avg_val $max_val]
        }
        incr i
}

set sorted_runs [lsort -real -index 1 $runs]

set fp_out [open $output_file "w"]
puts $fp_out $header_line
puts $fp_out "Run Number        Average         Maximum"
puts $fp_out "----------        -------         -------"

foreach r $sorted_runs {
        set r_num [lindex $r 0]
        set r_avg [lindex $r 1]
        set r_max [lindex $r 2]

        puts $fp_out [format "%-17s %-15.1f %s" $r_num $r_avg $r_max]
}

close $fp_out



# HW1
# represntive - maayan friedman 217374008 , naama zur 217264332
# ------------------------------------------------------------------------------
set ID_NUMBER  "217374008"
set STUDENTS   "Maayan Friedman 217374008 Naama Zur 217264332"

# Header line of both output files
set header "# EX_1 $STUDENTS"

# The ID is kept as a string for the file names
# for arithmetic we convert it to a decimal integer (an ID starting with 0 would otherwise be read as octal)
scan $ID_NUMBER %d id_value

set part1_file "${ID_NUMBER}.part1"
set part2_file "${ID_NUMBER}.part2"

# Random integer in the range [min, max] (both inclusive)
proc rand_int { min max } {
    return [expr { $min + int(rand() * ($max - $min + 1)) }]
}

# Part 1: loop that runs N times. In each run, randomizes an integer M, generates M random numbers, and compute their average. writes part1 file.
proc part1 { file_name header id_value } {
    # Seed the pseudo-random generator with the ID
    expr { srand($id_value) }

    set N [rand_int 10 20]

    set fh [open $file_name w]
    puts $fh $header
    puts $fh "Number of runs: N = $N"

    for { set run 1 } { $run <= $N } { incr run } {
        if { $run > 1 } {
            puts $fh ""
        }
        puts $fh "Run Number: $run"
        puts $fh "-------------"

        set M [rand_int 5 30]
        puts $fh "M = $M"

        set sum 0
        for { set i 0 } { $i < $M } { incr i } {
            set value [rand_int 0 $id_value]
            puts $fh $value
            set sum [expr { $sum + $value }]
        }
        puts $fh "Average = [format {%.1f} [expr { double($sum) / $M }]]"
    }
    close $fh
}

# Part 2: open and parse part1 file and writes part2 file.
proc part2 { in_file out_file header } {
    # Each entry of runs is: {run_number average maximum}
    set runs {}
    set run ""

    set fh [open $in_file r]
    while { [gets $fh line] >= 0 } {
        set line [string trim $line]
        if { [regexp {^Run Number:\s*(\d+)$} $line -> number] } {
            set run $number
            set max ""
        } elseif { [regexp {^Average\s*=\s*(\S+)$} $line -> average] } {
            lappend runs [list $run $average $max]
        } elseif { $run ne "" && [regexp {^\d+$} $line] } {
            # A random value of the current run
            if { $max eq "" || $line > $max } {
                set max $line
            }
        }
    }
    close $fh

    # Sort by average, ascending
    set runs [lsort -real -increasing -index 1 $runs]

    set fh [open $out_file w]
    puts $fh $header
    puts $fh [format {%-14s%-14s%s} "Run Number" "Average" "Maximum"]
    puts $fh [format {%-14s%-14s%s} "------------" "-------" "-------"]
    foreach entry $runs {
        lassign $entry number average max
        puts $fh [format {%-14s%-14s%s} $number $average $max]
    }
    close $fh
}

part1 $part1_file $header $id_value
part2 $part1_file $part2_file $header

puts "Created $part1_file and $part2_file"
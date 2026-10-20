# HW1 - koren ben signor - 322593997 and etai cohen - 318672334

# ---- part A: ----
set id 322593997
set name "KOREN BEN SIGNOR"
set partner_id "318672334"
set partner_name "ETAI COHEN"
set N 10

expr {srand($id)}

set fh [open "${id}.part1" w]

puts $fh "# EX_1 $name $id $partner_name $partner_id"
puts $fh "Number of runs: N = $N"

for {set i 1} {$i <= $N} {incr i} {
    set M [expr {5 + int(rand() * 26)}]
    set sum 0

    puts $fh "Run Number: $i"
    puts $fh "-------------"
    puts $fh "M = $M"

    for {set j 0} {$j < $M} {incr j} {
        set number [expr {int(rand() * ($id + 1))}]
        set sum [expr {$sum + $number}]
        puts $fh $number
        
    }

    set average [expr {double($sum) / $M}]
    puts $fh [format "Average = %.1f" $average]

    if {$i < $N} {
        puts $fh ""
    }
}

close $fh



# ---- part B: ----

set fh [open "${id}.part1" r]
gets $fh header

set results {}

while {[gets $fh line] >= 0} {
    if {[regexp {^Run Number: ([0-9]+)$} $line match run_number]} {
        set maximum 0
    } elseif {[regexp {^[0-9]+$} $line]} {
        if {$line > $maximum} {
            set maximum $line
        }
    } elseif {[regexp {^Average = ([0-9]+\.[0-9]+)$} $line match average]} {
        lappend results [list $run_number $average $maximum]
    }
}

close $fh

set results [lsort -real -index 1 $results]

set fh [open "${id}.part2" w]

puts $fh $header
puts $fh [format "%-14s%-14s%s" "Run Number" "Average" "Maximum"]
puts $fh [format "%-14s%-14s%s" "------------" "-------" "-------"]

foreach row $results {
    set run_number [lindex $row 0]
    set average [lindex $row 1]
    set maximum [lindex $row 2]

    puts $fh [format "%-14s%-14s%s" $run_number $average $maximum]
}

close $fh
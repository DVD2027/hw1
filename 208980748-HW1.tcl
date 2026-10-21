# ---------- Settings ----------
set id "208980748"
set names "Tal Barmocha 208980748 Michael Mostytskyy 322467168"
expr {srand($id)}
# ---------- Part 1 ----------
set fh [open "$id.part1" w] ;# open the file for writing
puts $fh "# EX_1 $names"
set N [expr {int(rand()*11) + 10}]
puts $fh "Number of runs: N = $N"
for { set i 1 } { $i <= $N} { incr i } {
  puts $fh "Run Number: $i"
  puts $fh "-------------"
  set M [expr {int(rand()*26) + 5}]
  puts $fh "M = $M"
  set sum 0
  for { set j 1 } { $j <= $M} { incr j } {
    set num [expr {int(rand() * ($id + 1))}]
    puts $fh "$num"
    incr sum $num
    }
  set avg [expr {double($sum) / $M}]
  puts $fh "Average = [format {%0.1f} $avg]"
  puts $fh ""
  }
close $fh

# ---------- Part 2 ----------
## First read from the part1 file
set fh [open "$id.part1" r]     ;# open the file for reading
set runs {}                     ;# empty list, will collect the results

while { [gets $fh line] >= 0 } {
    if {[regexp {^Run Number: (\d+)$} $line match run]} {
        set max -1
    } elseif {[regexp {^(\d+)$} $line match num]} {
        if {$num >= $max} {set max $num}
    } elseif {[regexp {^Average = (\d+\.\d+)$} $line match avg]} {
        lappend runs [list $run $avg $max]
    }
}
close $fh

## wrtie the results to part2
set fh [open "$id.part2" w] ;# open the file for writing
set sorted [lsort -real -index 1 $runs]
puts $fh "# EX_1 $names"
puts $fh [format {%-14s%-14s%s} "Run Number" "Average" "Maximum"]
puts $fh [format {%-14s%-14s%s} "------------" "-------" "-------"]
foreach rec $sorted {
    set run [lindex $rec 0]
    set avg [lindex $rec 1]
    set max [lindex $rec 2]
    puts $fh [format {%-14s%-14s%s} "$run" "$avg" "$max"]
}
close $fh


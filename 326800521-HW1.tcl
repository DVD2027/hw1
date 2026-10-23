# ---------- settings ----------
set id 326800521
set header "# EX_1 Nour Alemy 326800521 Nagham Khatib 325394989"
expr { srand($id) }

# ---------- Part 1 ----------
set fh [open "${id}.part1" w]
puts $fh $header

set N [expr { 10 + int(rand()*11) }]
puts $fh "Number of runs: N = $N"

for { set r 1 } { $r <= $N } { incr r } {
    puts $fh "Run Number: $r"
    puts $fh "-------------"
    set M [expr { 5 + int(rand()*26) }]
    puts $fh "M = $M"
        set sum 0
    for { set i 1 } { $i <= $M } { incr i } {
        set x [expr { int(rand()*($id + 1)) }]
        puts $fh $x
        set sum [expr { $sum + $x }]
    }
      
      puts $fh "Average = [format %.1f [expr { double($sum) / $M }]]"   
      puts $fh ""
}
close $fh


# example.tcl — HW1 warm-up
#
# If you can see this file, you checked out tag v1.0 correctly and you are
# working on your own branch (the main branch has only README.md).
#
# Run it with:   tclsh example.tcl
#
# It demonstrates a few of the Tcl basics from Part A of the README.
# It does NOT solve the assignment. When you start your solution, delete it:
#
#   git rm example.tcl
#   git commit -m "Remove example"

# --- Variables, expr and command substitution --------------------------------
set course "Digital VLSI Design"
set year   2027
puts "Welcome to $course [expr {$year - 1}]-[expr {$year % 100}]"

# --- Lists and foreach --------------------------------------------------------
set tools {Xcelium Genus Innovus Voltus}
puts "This semester you will use [llength $tools] Cadence tools:"
foreach tool $tools {
    puts "  - $tool"
}

# --- Procedures ---------------------------------------------------------------
proc square {x} {
    return [expr {$x * $x}]
}
puts "square(7) = [square 7]"

# --- Formatted output ---------------------------------------------------------
puts [format "%-10s|%8.3f|" "pi" 3.14159265]
puts [format "%-10s|%8d|" "answer" 42]

# --- Writing and reading a file -----------------------------------------------
set fname "example_output.txt"
set fh [open $fname w]
puts $fh "line one"
puts $fh "line two"
close $fh

set fh [open $fname r]
while {[gets $fh line] >= 0} {
    puts "read back: $line"
}
close $fh
file delete $fname

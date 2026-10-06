# HW1 — The Tool Command Language (Tcl)

**Course:** 83-612 – Digital VLSI Design, Bar-Ilan University
**Year:** 2026–27
**Weight:** 10% of the homework grade · **Deadline:** Saturday 23:59 of the submission week (see the syllabus timeline in `#important-resources` on the DVD2026-27 Discord) · **Submitted in pairs** — branch name = the representative's ID.  
**Grading:** 20% automatic grader at the deadline + 80% in-lab evaluation in the following lab. **You can only be evaluated if your homework was pushed before that lab session starts**; every week of delay costs 5 points off this assignment's grade. See [HW0 – Homework rules](https://github.com/DVD2027/hw0#3-homework-rules-all-assignments).

In this exercise you write a Tcl script that (1) generates random numbers and computes per-run averages, and (2) parses that output to produce a sorted summary. Tcl is the shell language of almost every EDA tool, and every later assignment relies on it. The exercise is intentionally simple — follow the instructions; the goal is to learn the language, not to solve a hard problem.

> Based on course material by Prof. Adam Teman (EnICS Labs). Read [HW0](https://github.com/DVD2027/hw0) first for the environment and the submission rules.

- [Part A — Tcl primer](#part-a--tcl-primer)
- [Part B — The assignment](#part-b--the-assignment)

---

# Part A — Tcl primer

Tcl ("Tool Command Language") is a **string-based, interpreted** command language. You will usually use it inside an EDA tool shell (Genus, Innovus, Xcelium, ...), but a standalone interpreter is available on any Linux machine:

```text
%> tclsh
```

Video course: <https://enicslabs.com/short-courses/> — [Part 1](https://youtu.be/o_mhSa5HQCc), [Part 2](https://youtu.be/T_4Bvg6np08).

## A.1 Basics

```tcl
% puts "hello, world!"          ;# print a string (with newline)
hello, world!
% set a 5                       ;# a = 5
% puts $a                       ;# $ evaluates a variable
5
% expr 2+2                      ;# evaluate a math expression
4
% puts "\$a"                    ;# backslash escapes special characters
$a
```

- A script is a sequence of commands separated by **newlines or semicolons**.
- `#` starts a comment. **To comment after a command on the same line, first end the command with `;`** — e.g. `set a 5 ;# comment`.
- A command is a word followed by zero or more arguments separated by whitespace.
- **Command substitution** uses square brackets `[...]`, evaluated first (Polish notation).
- Arguments are **quoted by default** — evaluation must be requested explicitly:

```tcl
% set a 2+2               ;# $a is the string "2+2"
% set b [expr 2+2]        ;# $b is 4
% puts "$a = $b"
2+2 = 4
```

## A.2 "Everything is a string"

Tcl has exactly **one type: the string**. The interpreter performs three kinds of substitution — **command** (`[...]`), **variable** (`$name`) and **backslash** (`\`). Commands receive strings and decide how to interpret them; `4+4` is just a string until you pass it to `expr` (or `eval`).

## A.3 Variables and lists

```tcl
% set a_string "hello"
% puts "This is a string: $a_string"
This is a string: hello
% set an_int 5
% puts "And this is a number: [expr $an_int + 1]"
And this is a number: 6
% set an_int                    ;# set with one argument returns the value
5
% set the_fourth_letter "d"
% puts "abc${the_fourth_letter}efgh"   ;# braces delimit the variable name
abcdefgh
```

Lists are whitespace-separated strings. Three ways to create one:

```tcl
% set list1 {1 2 3 4}           ;# braces: NO substitution inside
% set list2 "a b c d"           ;# quotes: substitution happens
% set list3 [list 1 a b 2 3 c]  ;# list command
% set a 3; set list4 {1 2 $a}; set list5 "1 2 $a"
% puts "list4 is: $list4 \nlist5 is: $list5"
list4 is: 1 2 $a
list5 is: 1 2 3
```

Iterating and manipulating lists:

```tcl
% foreach a $list5 { puts $a }
1
2
3
% llength $list5               ;# length
3
% lindex $list5 1              ;# element (indices start at 0)
2
% lindex $list5 end            ;# last element
3
% lindex $list5 end-1
2
% set mylist { a { b c } }     ;# nested lists
% puts [lindex $mylist 1 1]
c
% lappend list5 4; puts $list5 ;# append
1 2 3 4
```

Also useful: `concat`, `join`, `linsert`, `lrange`, `lreplace`, `lsearch`, `lsort`, `split`.

## A.4 Arrays (associative) and environment variables

A Tcl *array* is **associative** (like a Python dict / Perl hash), not a C array:

```tcl
% set student(Yossi) "Cohen"
% set student(Michal) "Levi"
% puts $student(Yossi)
Cohen
% array size student
2
% array names student
Yossi Michal
% foreach first_name [array names student] {
      puts "$first_name $student($first_name)"
  }
Yossi Cohen
Michal Levi
% puts $env(PWD)               ;# environment variables live in the env array
```

## A.5 Control flow

```tcl
if { $a == 5 } {
    puts "a equals five"
} elseif { $a == 4 } {
    puts "a equals four"
} else {
    puts "a is not four or five"
}

foreach item "item1 item2 item3" { puts "The current item is: $item" }

while { $i < 10 } { incr i }

for { set i 0 } { $i < 10 } { incr i } { puts $i }

switch $string {
    pattern1 { body1 }
    pattern2 { body2 }
    default  { body3 }
}
```

## A.6 Procedures

```tcl
proc plus { a b } {
    return [expr $a + $b]
}

proc plus_v2 { a b {to_print 1} } {     ;# to_print defaults to 1
    set c [expr $a + $b]
    if { $to_print } { puts "$a + $b = $c" }
    return $c
}

% set a [plus 2 2]      ;# 4
% plus_v2 2 2           ;# prints "2 + 2 = 4"
% plus_v2 2 2 0         ;# prints nothing
```

- Arguments and variables created inside a procedure are **local**; pass results back with `return`.
- To modify a global variable inside a procedure, declare it `global`:

```tcl
proc inc_a { } {
    global a
    incr a
}
```

(Namespaces are the cleaner, more advanced mechanism — Cadence uses them heavily.)

## A.7 Strings, formatting and regular expressions

```tcl
% if { "this string" == "this string" } { puts "Yes!" }
% string index "abcde" 2                  ;# c
% string length "abcde"                   ;# 5
% string first "de" "abcdebcdebc"         ;# 3
% string match "*@*.com" "me@me.com"      ;# 1 (glob match)
% puts [format "%f" 43.5]                 ;# 43.500000  (C printf style)
% puts [format "%e" 43.5]                 ;# 4.350000e+01
% puts [format "%d\t%s" 2 Levi]
% format {%0.2f} 3.14159265359            ;# 3.14
% format {%-15s%-15s%s} a b c             ;# left-aligned fixed-width columns
```

Regular expressions are one of the most important tools of a VLSI engineer — learn them:

```tcl
regexp {pattern} $string match sub1 sub2      ;# match (and capture groups)
regsub {pattern} $string replacement newVar   ;# substitute
```

## A.8 File I/O

```tcl
set fh [open "myfile.txt" r]     ;# open for reading
set fh [open "myfile.txt" w]     ;# open for writing (overwrites!)
set fh [open "myfile.txt" a]     ;# open for appending
set file_data [read $fh]         ;# read the whole file
while { [gets $fh line] >= 0 } { ;# read line by line
    puts $line
}
puts $fh "Some text"             ;# write (first argument = file handle)
close $fh
```

If you omit the file handle, `puts` writes to standard output (the screen).

## A.9 Math and system functions

```tcl
expr pow(2,10)          ;# also cos(), log10(), sqrt(), abs(), round(), int(), rand(), srand(), ...
expr 1/2                ;# 0   — integer division!
expr 1.0/2              ;# 0.5
expr double(1)/2        ;# 0.5
expr { srand(123456789) }   ;# seed the pseudo-random generator
expr { int(rand()*10) }     ;# random integer 0..9
clock format [clock seconds] -format %H:%M:%S
exec ls                 ;# run a Linux command
```

---

# Part B — The assignment

## B.1 Part 1: Calculate a running average

Write a loop that runs **N** times. In each run, randomize an integer **M**, generate **M** random numbers, and compute their average. Write everything to a file called **`<ID_NUMBER>.part1`**, formatted **exactly** like this example:

```text
# EX_1 Moshe Israeli 123456789
Number of runs: N = 2
Run Number: 1
-------------
M = 2
12345
67890
Average = 40117.5

Run Number: 2
-------------
M = 3
123
4567
89
Average = 1593.0
```

Randomization rules:

- **N** is in the range **10–20**.
- **M** is in the range **5–30**.
- The random **values** are in the range **0 to your ID number**.
- Pseudo-random generators always return the same sequence, so **seed the generator with your ID**, e.g. `expr { srand(012345678) }`.

## B.2 Part 2: Parse and analyze the file

Parsing and manipulating text files is a core skill of any backend engineer. The second part of the same script must **open and parse `<ID_NUMBER>.part1`** (do not reuse the in-memory values) and write **`<ID_NUMBER>.part2`** containing the runs **sorted by average (ascending)** together with the **maximum number** of each run. For the example above:

```text
# EX_1 Moshe Israeli 123456789
Run Number    Average       Maximum
------------  -------       -------
2             1593.0        4567
1             40117.5       67890
```

> **You MUST format both output files EXACTLY as shown** (with **both partners' names and IDs** in the header line).
> This includes how numbers are printed: compare your output to the examples above character by character, with your real ID-sized values (not only small test numbers). **The automatic grader checks your files against this format — any difference fails its checks.**

## B.3 What to submit

Place all files at the repository root:

| File | Content |
|------|---------|
| `ID-HW1.tcl` | Your complete Tcl script — **both parts in one script** |
| `<ID_NUMBER>.part1` | The output of Part 1 from your run |
| `<ID_NUMBER>.part2` | The output of Part 2 from your run |

```bash
tsmc65
mkdir -p DVD && cd DVD
git clone git@github.com:DVD2027/hw1.git
cd hw1
git checkout v1.0 -b <ID_NUMBER>
# ... write and run your script: tclsh ID-HW1.tcl ...
git add ID-HW1.tcl <ID_NUMBER>.part1 <ID_NUMBER>.part2
git commit -m "HW1 solution"
git push origin <ID_NUMBER>
```

## B.4 Checklist

- [ ] `ID-HW1.tcl` implements **both** parts in one script.
- [ ] The random generator is **seeded with my ID**.
- [ ] N, M and the values are within the required ranges.
- [ ] Part 2 reads its data by **parsing the `.part1` file**.
- [ ] Both output files match the format **exactly**, with both partners' names and IDs in the header.
- [ ] Our branch name is **exactly** the representative's ID (the same ID used for the seed), and we pushed to `origin <ID_NUMBER>` (never to `main`) before the deadline.

# הגדרת משתנים
set id 314826595
set file_part1 "${id}.part1"

# אתחול מחולל המספרים האקראיים (Seed) עם תעודת הזהות
expr { srand($id) }

# פתיחת קובץ הפלט הראשון לכתיבה
set fh1 [open $file_part1 w]

# כותרת
puts $fh1 "# EX_1 Idan Safadi 314826595 Bar zehavi 323014894"

# הגרלת מספר הריצות N (טווח 10 עד 20)
set N [expr { int(rand() * 11) + 10 }]
puts $fh1 "Number of runs: N = $N"

# לולאת הריצות
for {set i 1} {$i <= $N} {incr i} {
    puts $fh1 "Run Number: $i"
    puts $fh1 "-------------"

    # הגרלת M עבור הריצה הנוכחית (טווח 5 עד 30)
    set M [expr { int(rand() * 26) + 5 }]
    puts $fh1 "M = $M"

    # שימוש ב-0.0 כדי להבטיח חישוב בשברים עשרוניים ולא בשלמים
    set sum 0.0

    # הגרלת M מספרים בטווח של 0 עד תעודת הזהות
    for {set j 0} {$j < $M} {incr j} {
        set rand_val [expr { int(rand() * ($id + 1)) }]
        puts $fh1 $rand_val
        set sum [expr {$sum + $rand_val}]
    }

    # חישוב הממוצע לריצה הנוכחית
    set avg [format "%.1f" [expr {$sum / $M}]]
    puts $fh1 "Average = $avg"
    
    # הדפסת שורה ריקה בין ריצה לריצה (כמו בדוגמה)
    puts $fh1 ""
}

# סגירת הקובץ
close $fh1
puts "Part 1 completed! File $file_part1 was generated."

# ==========================================
# --- Part 2: Parsing and Analysis ---
# ==========================================

set file_part2 "${id}.part2"

# פתיחת הקובץ הראשון לקריאה
set fh1 [open $file_part1 r]



# רשימה לשמירת הנתונים של כל ריצה
set runs_list {}

set current_run ""
set current_max -1
set reading_numbers 0

# קריאת הקובץ שורה אחר שורה
while { [gets $fh1 line] >= 0 } {
    # הסרת רווחים מהצדדים
    set line [string trim $line]
    
    # דילוג על שורות ריקות
    if { $line == "" } continue
    
    # שימוש בביטויים רגולריים (Regex) לאיתור הנתונים
    if { [regexp {^Run Number:\s*(\d+)} $line match run_num] } {
        set current_run $run_num
        set current_max -1
        set reading_numbers 0
    } elseif { [regexp {^M\s*=\s*\d+} $line] } {
        # משורה זו מתחילים המספרים המוגרלים
        set reading_numbers 1
    } elseif { [regexp {^Average\s*=\s*([0-9.]+)} $line match avg] } {
        # שורת הממוצע מסמנת את סוף הריצה. נשמור את הנתונים כרשימה פנימית
        lappend runs_list [list $current_run $avg $current_max]
        set reading_numbers 0
    } elseif { $reading_numbers == 1 } {
        # קריאת המספרים האקראיים עצמם ומציאת המקסימום
        if { $line > $current_max } {
            set current_max $line
        }
    }
}
close $fh1

# מיון הרשימה לפי עמודת הממוצע (אינדקס 1) בסדר עולה
set sorted_runs [lsort -real -index 1 $runs_list]

# פתיחת קובץ הפלט השני לכתיבה
set fh2 [open $file_part2 w]

# כתיבת הכותרות בדיוק בפורמט הנדרש (כולל שימוש ב-format ליישור העמודות)

puts $fh1 "# EX_1 Idan Safadi 314826595 Bar zehavi 323014894"
puts $fh2 [format "%-14s%-14s%s" "Run Number" "Average" "Maximum"]
puts $fh2 [format "%-14s%-14s%s" "------------" "-------" "-------"]

# הדפסת הנתונים הממוינים לקובץ החדש
foreach item $sorted_runs {
    set r [lindex $item 0]
    set a [lindex $item 1]
    set m [lindex $item 2]
    puts $fh2 [format "%-14s%-14s%s" $r $a $m]
}
close $fh2

puts "Part 2 completed! File $file_part2 was generated."
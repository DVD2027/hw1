
set rep_name "Ester Turgeman"
set rep_id "322652579"
set partner_name "Shoham Haim"
set partner_id "212918924"


# Part 1: Calculate a running average and write to .part1

# אתחול המחולל האקראי עם תעודת הזהות של הנציגה
expr { srand($rep_id) }

# פתיחת קובץ part1 לכתיבה
set filename1 "${rep_id}.part1"
set f1 [open $filename1 w]

# כתיבת שורת הכותרת עם השמות ותעודות הזהות
puts $f1 "# EX_1 $rep_name $rep_id $partner_name $partner_id"

# הגרלת מספר הריצות N (בין 10 ל-20)
set N [expr { int(rand() * 11) + 10 }]
puts $f1 "Number of runs: N = $N"

# לולאה ראשית עבור כל ריצה
for {set i 1} {$i <= $N} {incr i} {
    puts $f1 "Run Number: $i"
    puts $f1 "------------"
    
    # הגרלת מספר הערכים M (בין 5 ל-30)
    set M [expr { int(rand() * 26) + 5 }]
    puts $f1 "M = $M"
    
    set sum 0
    
    # הגרלת M מספרים וחישוב סכום
    for {set j 0} {$j < $M} {incr j} {
        set num [expr { int(rand() * ($rep_id + 1)) }]
        puts $f1 $num
        set sum [expr { $sum + $num }]
    }
    
    # חישוב והדפסת הממוצע (המרת הסכום ל-double לשמירה על שבר עשרוני)
    set avg [format "%.1f" [expr { double($sum) / $M }]]
    puts $f1 "Average = $avg"
    
    # רווח של שורה בין ריצה לריצה, למעט הריצה האחרונה (כדי לתאום לדוגמה)
    if {$i < $N} {
        puts $f1 ""
    }
}

close $f1



# Part 2: Parse and analyze the file, write sorted to .part2

# פתיחת קובץ part1 לקריאה, וקובץ part2 לכתיבה
set f1_read [open $filename1 r]
set filename2 "${rep_id}.part2"
set f2 [open $filename2 w]

set all_runs {}
set current_max -1
set current_run 0

# קריאת הקובץ הראשון שורה אחר שורה
while { [gets $f1_read line] >= 0 } {
    
    # זיהוי שורת מספר ריצה (למשל: "Run Number: 1")
    if { [regexp {Run Number: ([0-9]+)} $line match run_num] } {
        set current_run $run_num
        set current_max -1 ;# איפוס המקסימום לריצה החדשה
        
    # זיהוי שורת ממוצע (למשל: "Average = 1593.0")
    } elseif { [regexp {Average = ([0-9.]+)} $line match avg_val] } {
        # הוספת הנתונים כרשימה פנימית לתוך הרשימה הכללית
        lappend all_runs [list $current_run $avg_val $current_max]
        
    # זיהוי שורה שמכילה רק מספרים (הערכים שהוגרלו)
    } elseif { [regexp {^[0-9]+$} $line] } {
        if { $line > $current_max } {
            set current_max $line
        }
    }
}

close $f1_read

# מיון הרשימה לפי הממוצע בסדר עולה (-real עבור מספרים, -index 1 עבור העמודה השנייה)
set sorted_runs [lsort -real -index 1 $all_runs]

# כתיבת הכותרות לקובץ part2 (בדיוק לפי רווחי הדוגמה)
puts $f2 "# EX_1 $rep_name $rep_id $partner_name $partner_id"
puts $f2 "Run Number   Average        Maximum"
puts $f2 "----------   -------        -------"

# כתיבת הנתונים הממוינים בפורמט מיושר
foreach run_data $sorted_runs {
    set r [lindex $run_data 0]
    set a [lindex $run_data 1]
    set m [lindex $run_data 2]
    
    # שימוש ב-format כדי לשמור על יישור עמודות מדויק (כמו ב-C/C++)
    puts $f2 [format "%-13s%-15s%s" $r $a $m]
}

close $f2
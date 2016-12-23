#! /bin/env tclsh

set pass "fbgdceah"
set safe "~"
set null ""

set fp [open "input" r]
set file_data [read $fp]
close $fp

set lines [lreverse [split $file_data "\n"]]
foreach line $lines {
	if {$line == ""} {
		continue
	}
	puts $pass
	puts $line
	set words [split $line " "]
	if {[lindex $words 0] == "swap"} {
		if {[lindex $words 1] == "position"} {
			set x [string index $pass [expr [lindex $words 2]]]
			set y [string index $pass [expr [lindex $words 5]]]

		} else {
			set x [lindex $words 2]
			set y [lindex $words 5]
		}
		regsub -all $x $pass $safe pass
		regsub -all $y $pass $x pass
		regsub -all $safe $pass $y pass

	} elseif {[lindex $words 0] == "rotate"} {
		if {[lindex $words 1] == "based"} {
			set x [string first [lindex $words 6] $pass]
			set i 0
			while {$i < [string length $pass]} {
				set tmp [expr $i + $i + 1]
				if {$i > 3} {
					incr tmp 1
				}
				set tmp [expr $tmp % [string length $pass]]
				if {$tmp == $x} {
					break
				}
				incr i
			}
			if {$i < $x} {
				set x [expr $x - $i]

			} else {
				set x [expr [string length $pass] - [expr $i - $x]]
			}
		} elseif {[lindex $words 1] == "right"} {
			set x [expr [lindex $words 2]]
			set x [expr $x % [string length $pass]]

		} else {
			set x [expr [lindex $words 2]]
			set x [expr $x % [string length $pass]]
			set x [expr [string length $pass] - $x]
		}
		set pass [string cat [string range $pass $x end] [string range $pass 0 [expr $x - 1]]]

	} elseif {[lindex $words 0] == "reverse"} {
		set x [expr [lindex $words 2]]
		set y [expr [lindex $words 4]]
		set tmp {}
		set i [expr $y + 1]
		while {$i > $x} {
			append tmp [string index $pass [incr i -1]]
		}
		set pass [string cat [string range $pass 0 [expr $x - 1]] $tmp [string range $pass [expr $y + 1] end]]

	} else {
		set x [string index $pass [expr [lindex $words 5]]]
		set y [expr [lindex $words 2]]
		regsub -all $x $pass $null pass
		set pass [string cat [string range $pass 0 [expr $y - 1]] $x [string range $pass $y end]]
	}
}

puts $pass

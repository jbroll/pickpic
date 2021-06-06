#!/usr/bin/env tclkit8.6
#
set HOME $::env(HOME)

source $HOME/.camera-sync               ; # Not UnSourced

proc echo { string { redirector - } { file - } { mode {} } } {
    switch -- $redirector {
	>       { set fp [open $file w$mode]	}
	>>      { set fp [open $file a$mode]	}
	default { set fp stdout		}
    }

    puts {*}[expr { $mode eq {} ? {} : "-nonewline" }] $fp $string
    if { [string compare $file -] } { close $fp }
}

proc camera-sync {} {
    foreach keyvalues [split [string map { = " " } [exec gphoto2 -q --list-files --parsable]] "\n"] {
        dict update keyvalues FILENAME camera_path FILEMTIME time {}

        set file [file tail $camera_path]
        set root [file rootname $file]
        set numb [string range $root 4 end]

        set date [clock format $time -format %Y-%m-%d]
        set file_path "$target/$date/$file"

        if { $numb <= $start || [file exists $file_path] } {
            puts "skip $file"
        } else {
            puts "get  $file"
            exec gphoto2 --get-file $camera_path --filename=$file_path
            echo [subst {
    # Config for b3sync.tcl
    #
    set start $numb
    set target $target
            }] > $HOME/.camera-sync
        }
    }
}

if { [file rootname [file tail $argv0]] eq "camera-sync" } {
    camera-sync
}

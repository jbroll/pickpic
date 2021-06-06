#!/usr/bin/env tclkit8.6
#
set HOME $::env(HOME)

source $HOME/.pickpic               ; # Not UnSourced

set root [file dirname [file normalize [info script]]]

source ../wapp/wapp.tcl
source ../wapp/wapp-static.tcl
source ../wapp/wapp-thread.tcl
source ../wapp/wapp-routes.tcl

package require jbr::print

wapp-static static
wapp-static $source images browse

proc navlinks { path } {
    set prev {}
    foreach part [split $path /] {
        append prev /$part
        wapp-trim [subst { <a href="$prev"> / $part</a> }]
    }
}

wapp-route DELETE /image PATH_TAIL {
    print  file delete $::source/$PATH_TAIL
    file delete $::source/$PATH_TAIL
}
wapp-route PUT /image PATH_TAIL {
    set dire [file dirname $PATH_TAIL]
    if { ![file exists $::target/$dire] } {
        print file mkdir $::target/$dire
        file mkdir $::target/$dire
    }
    print file copy $::source/$PATH_TAIL $::target/$PATH_TAIL
    file copy $::source/$PATH_TAIL $::target/$PATH_TAIL
}

proc wapp-page-images-directory { fileroot filetail } {
    set filetail [string trimleft $filetail /]

    wapp-trim {
        <head>
            <link rel="stylesheet" href="/static/style.css">
            <link rel="stylesheet" href="/static/view-bigimg.css">
            <script src="/static/view-bigimg.js"></script>
        </head>
    }

    set files [lsort -decreasing [glob -nocomplain -directory $fileroot -tails -- *]]

    wapp-trim { <body> }
    wapp-trim [navlinks images/$filetail]
    wapp-trim { <br><br> }

    foreach file $files {
        if { ![file isfile $fileroot/$file] } {
            wapp-trim [subst { <a href="/images/$filetail/$file" >$file</a><br> }]
        }
    }

    wapp-trim { <div id="imggrid" class="imggrid"> }
    foreach file $files {
        if { [file isfile $fileroot/$file] } {
            if { [string match *.jpg [string tolower $file]] } {
                wapp-subst [subst { <img src="/images/$filetail/$file" /> }]
            }
        }
    }
    wapp-trim { </div> }
    wapp-trim { <script src="/static/pickpic.js"></script> }
    wapp-trim { </body> }
}

proc wapp-default {} {
  set mname [wapp-param PATH_HEAD]
  if { $mname eq "" } {
      wapp-redirect /images
  }
}

try {
    exec camera-sync
}
wapp-start $argv

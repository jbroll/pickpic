# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

PickPic is a single-user image triage web app. It serves a directory of JPEGs as
a thumbnail grid in the browser; clicking a thumbnail opens a full-frame viewer
where arrow keys page through images, `s` saves the current image to a `target`
directory, and `d` deletes it from `source`. `camera-sync` is a companion script
that pulls images off a USB camera into `source` before triage.

## Build & run

`unsource` and `tclkit8.6` must be on PATH; the wapp framework must be checked
out at `../wapp` relative to this repo (a patched fork —
https://github.com/jbroll/wapp).

- `make` — builds the runnable scripts `pickpic` and `camera-sync` from the
  `.tcl` sources via `unsource`.
- `make install` — copies the built scripts to `$HOME/bin`.
- `./pickpic` — runs the web app (first calls `camera-sync`, retrying every 5s
  until the camera responds, then starts the wapp server). Pass wapp args like
  `--server 8080` through to `wapp-start`.
- `./camera-sync` — runs camera sync standalone.

**Edit the `.tcl` files, never the generated `pickpic` / `camera-sync`.** The
generated files are committed but are build artifacts: `unsource` inlines every
`source ../wapp/...` line into one standalone script. Lines tagged
`# Not UnSourced` (the `source $HOME/.pickpic` / `.camera-sync` config reads)
are deliberately left as runtime `source` calls. After changing a `.tcl` file,
run `make` so the artifact stays in sync.

There is no test suite or linter.

## Configuration (runtime, not in repo)

Both tools read a Tcl config file from `$HOME` at startup:

- `~/.pickpic` — sets `source` (dir to triage) and `target` (dir to save picks to).
- `~/.camera-sync` — sets `start` (skip camera files numbered ≤ this) and
  `target` (dir to download into). `camera-sync` **rewrites this file** after each
  download to advance `start`, so it is both config and persisted state.

## Architecture

Two layers communicate over HTTP via REST verbs on `/image/<path>`:

**Backend — `pickpic.tcl`** (Tcl, on the wapp framework):
- `wapp-static static` serves the `static/` assets; `wapp-static $source images browse`
  serves the configured image directory under the `/images` URL prefix.
- `wapp-page-images-directory` renders the thumbnail-grid HTML page for a
  directory: subdirectory links plus an `<img>` per `.jpg` (sorted descending),
  wrapped in `<div id="imggrid">`.
- `wapp-route PUT /image` copies `source/<path>` → `target/<path>` (the save).
- `wapp-route DELETE /image` deletes `source/<path>` (the delete).
- `wapp-default` redirects `/` to `/images`.

**Frontend — `static/pickpic.js`** wires the grid: clicking an `IMG` opens the
viewer (`view-bigimg.js`, a vendored third-party lightbox) and tracks the shown
element. Keydown handlers map `ArrowLeft/Right` to sibling navigation, `s` to a
`PUT` and `d` to a `DELETE` against `/image/<path>` (synchronous XHR), updating
the DOM to match. So the keybindings in the UI map directly onto the two backend
routes.

`camera-sync.tcl` shells out to a patched `gphoto2`
(https://github.com/jbroll/gphoto2): lists camera files, and for each file
newer than `start` that isn't already downloaded, copies it to
`target/<YYYY-MM-DD>/<file>` and advances `start` in `~/.camera-sync`.

# Package
import std/[os, strutils]

version       = "0.8.4"
author        = "Dominik Picheta"
description   = "The Nim toolchain installer."
license       = "BSD"

srcDir = "src"
binDir = "bin"
bin = @["choosenim"]

skipExt = @["nim"]

# Dependencies

# Note: https://github.com/dom96/choosenim/issues/233 (need to resolve when updating Nimble)
requires "nim >= 1.2.6", "nimble >= 0.14.2"
when defined(macosx):
  requires "libcurl >= 1.0.0"
requires "analytics >= 0.3.0"
requires "osinfo >= 0.3.0"
requires "zippy >= 0.7.2"
when defined(windows):
  requires "puppy 1.5.4"

taskRequires "release", "forge"

task release, "Builds all release binaries":
  exec "forge release --version=" & version
  mkdir "bin"
  for dir in listDirs("dist/"):
    # Chop off the -gnu/-none/-whatever
    # Makes it easier to select binaries later
    # Note: Might cause problems if people want musl builds? Can we even detect that?
    let parts = dir.rsplit('-', 1)
    assert parts.len == 2, $parts
    var name = parts[0]
    name.removePrefix("dist" & DirSep)
    cpFile dir/"choosenim", "bin"/name

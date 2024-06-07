# This file is embedded in the `choosenim` executable and is written to
# ~/.nimble/bin/. It emulates a portable symlink with some nice additional
# features.

import strutils, os, osproc

import nimblepkg/[cli, options, version]
import nimblepkg/common as nimbleCommon
import cliparams
from common import ChooseNimError, mingwProxies

proc main(params: CliParams) {.raises: [ChooseNimError, ValueError].} =
  let exePath = getExePath(params, getAppFilename().extractFilename)
  if not fileExists(exePath):
    raise newException(ChooseNimError,
        "Requested executable is missing. (Path: $1)" % exePath)

  try:
    # Launch the desired process.
    let p = startProcess(exePath, args=commandLineParams(),
                         options={poParentStreams})
    let exitCode = p.waitForExit()
    p.close()
    quit(exitCode)
  except Exception as exc:
    raise newException(ChooseNimError,
        "Spawning of process failed. (Error was: $1)" % exc.msg)

when isMainModule:
  var error = ""
  var hint = ""
  var params = newCliParams(proxyExeMode = true)
  try:
    parseCliParams(params, proxyExeMode = true)
    main(params)
  except NimbleError as exc:
    (error, hint) = getOutputInfo(exc)

  if error.len > 0:
    displayTip()
    display("Error:", error, Error, HighPriority)
    if hint.len > 0:
      display("Hint:", hint, Warning, HighPriority)

    display("Info:", "If unexpected, please report this error to " &
            "https://github.com/ire4ever1190/choosenim", Warning, HighPriority)
    quit(1)

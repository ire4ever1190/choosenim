import nimblepkg/version

type
  ChooseNimError* = object of NimbleError

const
  chooseNimVersion* {.strdefine: "NimblePkgVersion".}= "0.0.0"

  proxies* = [
      "nim",
      "nimble",
      "nimgrep",
      "nimpretty",
      "nimsuggest",
      "testament",
      "nim-gdb",
      "atlas",
      "nim_dbg"
    ]

  mingwProxies* = [
    "gcc",
    "g++",
    "gdb",
    "ld"
  ]

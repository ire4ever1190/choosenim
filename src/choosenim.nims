when defined(macosx):
  switch("define", "curl")
elif not (defined(windows) or defined(android)):
  switch("define", "curl")

# We don't need it, but nimble does for SslError import
switch("define", "ssl")

# Package
version       = "0.5.0"
author        = "Andre Weissflog, Garett Bass, Gustav Olsson"
description   = "Nim bindings for the sokol C headers"
license       = "MIT"
srcDir        = "src"
skipDirs      = @["examples"]

# Dependencies
requires "nim >= 1.4.4"
import strformat

# Tasks
task clear, "Runs the clear example":
  exec "nim r examples/clear"

task triangle, "Runs the triangle example":
  exec "nim r examples/triangle"

task quad, "Runs the quad example":
  exec "nim r examples/quad"

task cube, "Runs the cube example":
  exec "nim r examples/cube"

task blend, "Runs the blend example":
  exec "nim r examples/blend"

task build_all, "Build all examples":
  # hmm, is there a better way?
  let examples = [
    "clear",
    "triangle",
    "quad",
    "cube",
    "blend"
  ]
  for example in examples:
    when defined(windows):
      exec &"nim c --cc:vcc --debugger:native examples/{example}"
    else:
      exec &"nim c --debugger:native examples/{example}"

task shaders, "Compile all shaders (requires ../sokol-tools-bin)":
  let shaders = [
    "triangle",
    "quad",
    "cube",
    "blend"
  ]
  let binDir = "../sokol-tools-bin/bin/"
  let shdcPath = 
    when defined(windows):
      &"{binDir}win32/sokol-shdc"
    elif defined(macosx) and defined(arm64):
      &"{binDir}osx_arm64/sokol-shdc"
    elif defined(macosx):
      &"{binDir}osx/sokol-shdc"
    else:
      &"{binDir}linux/sokol-shdc"
  for shader in shaders:
    let cmd = &"{shdcPath} -i examples/shaders/{shader}.glsl -o examples/shaders/{shader}.nim -l glsl330:metal_macos:hlsl4 -f sokol_nim"
    echo &"    {cmd}"
    exec cmd
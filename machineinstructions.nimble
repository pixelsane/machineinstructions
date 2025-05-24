# Package

version       = "0.1.0"
author        = "pixelsane"
description   = "Program a cute robot with one set of commands to escape tricky mazes. One shot, one run — no do-overs!"
license       = "Apache-2.0"
srcDir        = "src"
bin           = @["machineinstructions"]


# Dependencies

requires "nim >= 2.2.2"

# Tasks
import strformat

const debugOpts = "-d:debug"

const releaseOpts = "-d:danger"

task winrun, "Cross-compiles and runs MachineInstruction with Wine":
  exec &"nim c -r {releaseOpts} --app:gui -d:mingw -o:dist/win/machineinstructions.exe src/machineinstructions.nim"

task runr, "Runs MachineInstruction for current platform":
 exec &"nim c -r {releaseOpts} -o:dist/linux/machineinstructions src/machineinstructions.nim"

task rund, "Runs debug MachineInstruction for current platform":
 exec &"nim c -r {debugOpts} -o:debug-builds/machineinstructions src/machineinstructions.nim"

task release, "Builds MachineInstruction for current platform":
 exec &"nim c {releaseOpts} -o:dist/linux/machineinstructions src/machineinstructions.nim"

task webd, "Builds debug MachineInstruction for web":
 exec &"nim c {debugOpts} -d:emscripten -o:/debug-builds/machineinstructions.html src/machineinstructions.nim"

task webr, "Builds release MachineInstruction for web":
 exec &"nim c {releaseOpts} -d:emscripten -o:/dist/web/machineinstructions.html src/machineinstructions.nim"

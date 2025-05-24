import raylib
import world, entity, stack, embeds

const 
  screenW = 640
  screenH = 360

type Clickable = object
  text: string
  area: Rectangle
  clicked: bool
  hovering: bool

var
  robo : Entity
  
proc progressLevels*(robo: var Entity) =
  let 
    finishGrid = checkpointOfGrid(level(getLevel()), Finish)
    reachedEnd = 
      robo.pos.x >= finishGrid.x and 
      robo.pos.y >= finishGrid.y and 
      robo.pos.x < finishGrid.x + 16 and
      robo.pos.y < finishGrid.y + 16

  if reachedEnd:
    setLevel(getLevel() + 1)
    moveEntToCheckpoint robo
    stopResolve()

proc debugInitRobo = # after debug remove the exported var
  robo.texture = loadTexture "res/robo1.png"
  robo.direction = Neutral
  setSpeed(robo, 30)
  unusedEmbeds.add Embed(kind: TurnCCW)
  unusedEmbeds.add Embed(kind: TurnCW)
  unusedEmbeds.add Embed(kind: Go)


proc draw =
  drawWorld()
  drawRobo robo
  drawMachine()
  resolveStackUpdate(getEmbeds(), robo)
proc update =
  updateRobo(robo, activeCollisionGrid())
  updateMachine()
  progressLevels robo

proc init =
  initWindow(screenW, screenH, "Machine Instructions: Jam Edition")
  setTargetFPS 60
  initWorld()
  initMachine()
  setLevel(0)
  moveEntToCheckpoint(robo)
  debugInitRobo()
  showMachine = true

proc cleanup =
  defer: closeWindow() # tail
  
proc main =
  init()
  while not windowShouldClose():
    beginDrawing()
    clearBackground(BLACK)
    draw()
    endDrawing()

    update()

  cleanup()


when isMainModule:
  main()


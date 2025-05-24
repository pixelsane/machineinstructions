import raylib
import world, entity, stack

const 
  screenW = 640
  screenH = 360


var
  robo : Entity
  embeds: Stack
  

proc debugInitRobo =
  robo.texture = loadTexture "res/robo1.png"
  robo.direction = Left
  setSpeed(robo, 20)
  #embeds.add Embed(
  #  kind: TurnCW,
  #)
  #embeds.add Embed(
  #  kind: TurnCCW,
  #)
  embeds.add Embed(
    kind: TurnCW
  )

  embeds.add Embed(
    kind: TurnCCW
  )

  embeds.add Embed(
    kind: TurnCCW
  )

proc draw =
  drawWorld()
  drawRobo robo

proc update =
  updateRobo(robo, activeCollisionGrid())
  progressLevels robo
  resolveStackUpdate(embeds, robo)

proc init =
  initWindow(screenW, screenH, "Machine Instructions: Jam Edition")
  setTargetFPS 60
  initWorld()
  setLevel(0)
  moveEntToCheckpoint(robo)
  debugInitRobo()

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


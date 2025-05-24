import json, math, sequtils
import raylib

const
  Start* = 1
  Finish* = 2
  Solid* = 1

type 
  CollGrid* = seq[seq[bool]]
  Vector2t* = object
    x*: int
    y*: int


var 
  tileset : Texture2D
  rawJSON: JsonNode
  levels: JsonNode
  currentLevel: int
  currentCollGrid: CollGrid

proc level*(num: int) : JsonNode =
  levels[num]


func tileToPixel*(val: Vector2t, gridSize: int = 16): Vector2 =
  Vector2(
    x: float32(val.x * gridSize),
    y: float32(val.y * gridSize)
  )

proc collisionGrid*(level: JsonNode, targetValue: int): CollGrid =
  for layer in level["layerInstances"].elems:
    if layer["__identifier"].getStr == "Collision":
      let csv = layer["intGridCsv"].elems
      let w = layer["__cWid"].getInt
      let h = layer["__cHei"].getInt

      var grid = newSeqWith(h, newSeq[bool](w))

      for i, val in csv:
        if val.getInt == targetValue:
          let x = i mod w
          let y = i div w
          grid[y][x] = true

      return grid

  return @[]

proc isBlocked*(pos: Vector2t, collision: CollGrid) : bool =
  if pos.y < 0 or pos.y >= collision.len: return true
  if pos.x < 0 or pos.x >= collision.len: return true
  return collision[pos.y][pos.x]

proc checkpointOfGrid*(level: JsonNode, targetValue: int): Vector2t =
  for layer in level["layerInstances"].elems:
    if layer["__identifier"].getStr == "Checkpoints":
      let csv = layer["intGridCsv"].elems
      let cWid = layer["__cWid"].getInt
      for i, val in csv:
        if val.getInt == targetValue:
          return Vector2t(x: (i mod cWid), y: (i div cWid))
  return Vector2t(x: -1, y: -1)


proc drawLevel(levelNum: int) =
  let 
    instance = levels[levelNum]["layerInstances"]

  for layer in instance:
    if layer["__type"].getStr in ["Tiles", "AutoLayer"]:
      for tile in layer["gridTiles"].getElems:
        let
          px = tile["px"].getElems    # Position to draw on screen
          src = tile["src"].getElems  # Position in tileset texture
          tileRect = Rectangle(
            x: float(src[0].getInt), 
            y: float(src[1].getInt), 
            width: 16, 
            height: 16
          )
          pos = Vector2(x: float(px[0].getInt), y: float(px[1].getInt))

        drawTexture(tileset, tileRect, pos, WHITE)

proc initLDTK =
  rawJSON = parseJson(readFile("mi_tiling.ldtk"))
  levels = rawJSON["levels"]
  let tilesetPath = rawJSON["defs"]["tilesets"][0]["relPath"].getStr
  tileset = loadTexture tilesetPath

proc activeCollisionGrid*() : CollGrid = currentCollGrid
proc updateCollGrid*() = # call only when level changes or at special cases
  currentCollGrid = collisionGrid(level(currentLevel), Solid)


proc setLevel*(value: int) =
  currentLevel = value
  updateCollGrid()

proc getLevel* : int = currentLevel

proc initWorld* =
  initLDTK()
  updateCollGrid()

proc drawWorld* = 
  drawLevel currentLevel

proc updateWorld* =
  discard

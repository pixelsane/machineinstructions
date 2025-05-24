import raylib, world

type
  Direction* = enum Neutral, Left, Right, Down, Up
  Entity* = object
    id*: int
    pos*: Vector2t
    moveTimer*: float32
    direction*: Direction
    speed*: float32
    texture* : Texture2D
    resolveStack*: bool


proc canMoveTo*(pos: Vector2t, dir: Direction, grid: CollGrid): bool =
  var next = pos
  case dir
  of Up:    next.y -= 1
  of Down:  next.y += 1
  of Left:  next.x -= 1
  of Right: next.x += 1
  of Neutral: return false

  if next.y < 0 or next.y >= grid.len: return false
  if next.x < 0 or next.x >= grid[0].len: return false

  return not grid[next.y][next.x]


proc updateRobo*(robo: var Entity, grid: CollGrid) =
  if robo.moveTimer >= 10.0: 
    robo.moveTimer = 0

    if canMoveTo(robo.pos, robo.direction, grid):
      robo.resolveStack = false
      case robo.direction
      of Up:
        robo.pos.y -= 1
      of Down:
        robo.pos.y += 1
      of Left:
        robo.pos.x -= 1
      of Right:
        robo.pos.x += 1
      else:
        discard

  if canMoveTo(robo.pos, robo.direction, grid):
    robo.moveTimer += getFrameTime() * robo.speed
  else:
    robo.resolveStack = true



proc drawRobo*(robo: Entity, gridSize: float32 = 16) =
  let
    moveProgress = robo.moveTimer / 10.0
    basePos = tileToPixel robo.pos 
    src = Rectangle(x: 0, y: 0, width: 32, height: 32) # use for animation later
    tint = WHITE

    offset = case robo.direction
      of Up:    Vector2(x: 0, y: -float32(moveProgress * gridSize))
      of Down:  Vector2(x: 0, y:  float32(moveProgress * gridSize))
      of Left:  Vector2(x: -float32(moveProgress * gridSize), y: 0)
      of Right: Vector2(x:  float32(moveProgress * gridSize), y: 0)
      of Neutral: Vector2(x: 0, y: 0)

    pos = Vector2(
      x: basePos.x + offset.x,
      y: basePos.y + offset.y
    )

  drawTexture(robo.texture, src, pos, tint)

proc setSpeed*(entity: var Entity, value: float32) =
  entity.speed = value

proc moveEntToCheckpoint*(ent: var Entity, levelNum: int = getLevel()) =
  ent.pos = checkpointOfGrid(level(levelNum), Start)


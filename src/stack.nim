import raylib
import entity

const
  DEBUGPRINT = true

type
  EmbedType* = enum Go, TurnCW, TurnCCW
  Trigger* = enum Collision, Wait
  Embed* = object
    kind*: EmbedType
    trigger*: Trigger
  Stack* = seq[Embed]

proc turnCW*(robo: var Entity) =
  case robo.direction
  of Up:
    robo.direction = Right
  of Down:
    robo.direction = Left
  of Left:
    robo.direction = Up
  of Right:
    robo.direction = Down
  of Neutral:
    robo.direction = Right

proc turnCCW*(robo: var Entity) =
  case robo.direction
  of Up:
    robo.direction = Left
  of Down:
    robo.direction = Right
  of Left:
    robo.direction = Down
  of Right:
    robo.direction = Up
  of Neutral:
    robo.direction = Left

proc resolveNow(embedType: EmbedType, robo: var Entity) =
  when DEBUGPRINT:
    echo "Resolving now: " & $embedType
  case embedType
  of TurnCCW: turnCCW(robo)
  of TurnCW: turnCW(robo)
  else: 
    if robo.direction == Neutral: robo.direction = Down

proc resolveStackUpdate*(stack: var Stack, robo: var Entity) =
  let
    tail = stack[^1]
    shouldResolveNow = robo.resolveStack

  if shouldResolveNow: 
    resolveNow(tail.kind, robo)
    robo.resolveStack = false
    stack.setLen(stack.len - 1)

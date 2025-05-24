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

var
  doResolve: bool

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
  else: return

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
  else: return

proc beginResolve* =
  doResolve = true

proc stopResolve* =
  doResolve = false

proc resolveNow(embedType: EmbedType, robo: var Entity) =
  case embedType
  of TurnCCW: turnCCW(robo)
  of TurnCW: turnCW(robo)
  else: return

  when DEBUGPRINT:
    echo "Resolving now: " & $embedType

proc resolveStackUpdate*(stack: var Stack, robo: var Entity) =
  if stack.len <= 0: return
  let
    tail = stack[^1]
    shouldResolveNow = robo.resolveStack and doResolve

  if shouldResolveNow: 
    resolveNow(tail.kind, robo)
    robo.resolveStack = false
    stack.setLen(stack.len - 1)

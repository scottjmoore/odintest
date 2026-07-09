package odintest

import "core:fmt"

DEFAULT_GAME :: Game  {
    isRunning = true,

    AddState = GameAddState,
    RemoveState = GameRemoveState,

    Update = GameUpdate,
    Draw = GameDraw
}

Game :: struct {
    isRunning: bool,
    states: [dynamic]^GameState,
    data: rawptr,

    AddState: proc(g: ^Game, gs: ^GameState) -> int,
    RemoveState: proc(g: ^Game, idx: int),

    Update: proc(g: Game),
    Draw: proc(g: Game)
}

GameAddState :: proc(g: ^Game, gs: ^GameState) -> int{
    fmt.println("GameAddState()")
    
    append(&g.states, gs)
    gs.game = g
    gs.index = len(g.states) - 1

    return gs.index
}

GameRemoveState :: proc(g: ^Game, idx: int) {
    fmt.println("GameRemoveState()")
    fmt.println("\t", idx)
    fmt.println("\t", g)

    ordered_remove(&g.states, idx)
    fmt.println("\t", g)
}

GameUpdate :: proc(g: Game) {
    fmt.println("GameUpdate()")
    for s in g.states {
        if s.state == .RUNNING {
            s->Update()
        }
    }
}
 
GameDraw :: proc(g: Game) {
    fmt.println("GameDraw()")
    for s in g.states {
        if s.state == .RUNNING {
            s->Draw()
        }
    }
}

DEFAULT_GAME_STATE :: GameState {
    state = .RUNNING,

    Pause = GameStatePause,
    Resume = GameStateResume,
    Stop = GameStateStop,
    Destroy = GameStateDestroy,

    Update = GameStateUpdate,
    Draw = GameStateDraw
}

GameState :: struct {
    state : GAME_STATE,
    game : ^Game,
    index : int,

    Pause: proc(gs: ^GameState),
    Resume: proc(gs: ^GameState),
    Stop: proc(gs: ^GameState),
    Destroy: proc(gs: ^GameState),

    Update: proc(gs: GameState),
    Draw: proc(gs: GameState)
}

GAME_STATE :: enum {
    RUNNING,
    PAUSED,
    STOPPED,
    DESTROYED
}

GameStatePause :: proc(gs: ^GameState) {
    fmt.println("GameStatePause()")
    fmt.println("\t", gs)

    if gs.state == .RUNNING {
        gs.state = .PAUSED
    }

    fmt.println("\t", gs)
}

GameStateResume :: proc(gs: ^GameState) {
    fmt.println("GameStateResume()")
    fmt.println("\t", gs)

    if gs.state == .PAUSED {
        gs.state = .RUNNING
    }

    fmt.println("\t", gs)
}

GameStateStop :: proc(gs: ^GameState) {
    fmt.println("GameStateStop()")
    fmt.println("\t", gs)

    gs.state = .STOPPED

    fmt.println("\t", gs)
}

GameStateDestroy :: proc(gs: ^GameState) {
    fmt.println("GameStateDestroy()")
    fmt.println("\t", gs)

    if gs.state == .STOPPED {
        gs.state = .DESTROYED
    }

    gs.game->RemoveState(gs.index)

    fmt.println("\t", gs)
}

GameStateUpdate :: proc(gs: GameState) {
    fmt.println("GameStateUpdate()")
    fmt.println("\t", gs)
}

GameStateDraw :: proc(gs: GameState) {
    fmt.println("GameStateDraw()")
    fmt.println("\t", gs)
}
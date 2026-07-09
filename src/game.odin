package odintest

import "core:fmt"

DEFAULT_GAME :: Game  {
    isRunning = true,

    PushState = GamePushState,
    PopState = GamePopState,

    Update = GameUpdate,
    Draw = GameDraw
}

Game :: struct {
    isRunning: bool,
    state: ^GameState,
    data: rawptr,

    PushState: proc(g: ^Game, gs: ^GameState),
    PopState: proc(g: ^Game),

    Update: proc(g: Game),
    Draw: proc(g: Game)
}

GamePushState :: proc(g: ^Game, gs: ^GameState) {
    fmt.println("GamePushState()")

    gs.previous = g.state
    gs.game = g
    g.state = gs

}

GamePopState :: proc(g: ^Game) {
    fmt.println("GamePopState()")
    g.state = g.state.previous
    g.state.previous = nil

    if g.state == nil {
        g.isRunning = false
    }
}

GameUpdate :: proc(g: Game) {
    fmt.println("GameUpdate()")
    g.state->Update()
}
 
GameDraw :: proc(g: Game) {
    fmt.println("GameDraw()")
        if g.state.state == .RUNNING {
            g.state->Draw()
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
    previous : ^GameState,

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

    gs.game->PopState()

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
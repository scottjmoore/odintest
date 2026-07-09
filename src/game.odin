package odintest

import "core:fmt"

DEFAULT_GAME :: Game  {
    isRunning = true,

    AddState = GameAddState,
    Update = GameUpdate,
    Draw = GameDraw
}

Game :: struct {
    isRunning: bool,

    states: [dynamic]^GameState,

    AddState: proc(g: ^Game, gs: ^GameState),
    
    Update: proc(g: Game),
    Draw: proc(g: Game)
}

GameAddState :: proc(g: ^Game, gs: ^GameState) {
    fmt.println("GameAddState()")
    append(&g.states, gs)
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
    //Stop = GameStateStop,
    //Destroy = GameStateDestroy,

    Update = GameStateUpdate,
    Draw = GameStateDraw
}

GameState :: struct {
    state : GAME_STATE,

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

GameStateUpdate :: proc(gs: GameState) {
    fmt.println("GameStateUpdate()")
    fmt.println("\t", gs)
}

GameStateDraw :: proc(gs: GameState) {
    fmt.println("GameStateDraw()")
    fmt.println("\t", gs)
}
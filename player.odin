package odintest

import "vendor:raylib"


Player :: struct {
    pos: raylib.Vector2,
    size: raylib.Vector2,
    vel: raylib.Vector2,
    jumping: bool,
    color: raylib.Color
}

@(private="file")
PlayerCreateZ :: proc() -> Player {
    return Player {
        {0, 0},
        {0, 0},
        {0, 0},
        false,
        {0, 0, 0, 0}
    }
}

@(private="file")
PlayerCreateP :: proc(pos: raylib.Vector2, size: raylib.Vector2, color: raylib.Color) -> Player {
   return Player {
        pos,
        size,
        {0,0},
        false,
        color
    }
}

PlayerCreate :: proc{PlayerCreateZ, PlayerCreateP}
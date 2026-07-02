package odintest

import "vendor:raylib"


Player :: struct {
    pos: raylib.Vector2,
    size: raylib.Vector2,
    vel: raylib.Vector2,
    jumping: bool,
    color: raylib.Color
}

PlayerCreate :: proc(pos: raylib.Vector2, size: raylib.Vector2, color: raylib.Color) -> Player {
   return Player {
        pos,
        size,
        {0,0},
        false,
        color
    }
}
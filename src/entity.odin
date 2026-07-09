package odintest

import "core:fmt"
import "core:math"
import "vendor:raylib"


ENTITY_STATE :: enum {
    ENABLED,
    DISABLED,
    DESTROYED
}

Entity :: struct {
    type: typeid,
    pos: raylib.Vector2,
    vel: raylib.Vector2,
    size: raylib.Vector2,
    angle: f32,
    color: raylib.Color,
    state: ENTITY_STATE,

    Draw: proc(rp: rawptr)
}
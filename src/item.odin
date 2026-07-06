package odintest

import "core:fmt"
import "core:math"
import "vendor:raylib"

Item :: struct {
    using entity: Entity,
    collected: bool
}

ItemCreate :: proc(pos: raylib.Vector2, size: raylib.Vector2, color: raylib.Color) -> Item {
    i: Item

    i.type = type_of(i)
    i.pos = pos
    i.size = size
    i.color = color
    i.collected = false

    i.Draw = ItemDraw

    return i
}

ItemDraw :: proc(rp: rawptr) {
    p := cast(^Item)rp

    raylib.DrawPoly(p.pos, 4, p.size.x, p.angle + 45, p.color)
}
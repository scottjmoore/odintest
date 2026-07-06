package odintest

import "core:math"
import "vendor:raylib"


Player :: struct {
    using entity: Entity,
    health: int,

    //Draw: proc(p: Player)
}

PlayerCreate :: proc(x: f32, y: f32, size: f32) -> Player {
    p: Player
    
    p.pos = {x, y}
    p.vel = {0, 0}
    p.size = {size, size}
    p.angle = 0
    p.color = {255,255,255, 255}

    p.health = 100

    p.Draw = PlayerDraw

    return p
}

PlayerDraw :: proc(rp: rawptr) {
    p := cast(^Player)rp

    raylib.DrawPoly(p.pos, 3, p.size.x, p.angle+30, p.color)
    raylib.DrawCircleV(p.pos + {math.sin(math.to_radians(p.angle))*24, -math.cos(math.to_radians(p.angle))*24}, 8, {255, 0, 0, 160})
    raylib.DrawCircleV(p.pos + {math.sin(math.to_radians(p.angle+120))*24, -math.cos(math.to_radians(p.angle+120))*24}, 8, {0, 255, 0, 160})
    raylib.DrawCircleV(p.pos + {math.sin(math.to_radians(p.angle+240))*24, -math.cos(math.to_radians(p.angle+240))*24}, 8, {0, 0, 255, 160})
    p.health += 1
}
package odintest

import "core:fmt"
import "core:math"
import "vendor:raylib"

EntityState :: enum {
    ENABLED,
    DISABLED,
    DESTROYED
}

Entity :: struct {
    pos: raylib.Vector2,
    vel: raylib.Vector2,
    size: raylib.Vector2,
    color: raylib.Color,
    angle: f32,
    state: EntityState,
    children: Entities,
}

Entities :: struct {
    entities: ^[dynamic]Entity,

    Add: proc(es: Entities, e: ^Entity) -> Entity,
}

EntitiesCreate :: proc() -> Entities {
    et: Entities

    fmt.println("Creating entities")

    et.entities = new([dynamic]Entity)

    et.Add = proc(es: Entities, e: ^Entity) -> Entity{
        e.children = EntitiesCreate()
        append(es.entities, e^)

        return e^
    }

    return et
}

EntitiesDestroy :: proc(es: Entities) { 
    fmt.println("Destroying entities")

    if len(es.entities) > 0 {        
        for e in es.entities {
            EntitiesDestroy(e.children)
        }

        delete(es.entities^)
    }
}
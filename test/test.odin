package test
import "core:fmt"

testing :: proc() {
    fmt.print("Testing!\n")
}

test_again :: proc(count:int) {
    for i:=0; i <= count; i=i+1 {
        fmt.print("Testing Again!\n")
    }
}
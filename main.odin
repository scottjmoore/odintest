package main
import "core:fmt"
import "test"

main :: proc() {
    when ODIN_DEBUG == true {
        fmt.print("Debuging\n")
    }
    
    fmt.print("Hello World!\n")
    test.testing()
    test.test_again(5)
}
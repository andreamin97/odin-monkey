package interpreter

import "core:mem"
import "core:fmt"
import "core:strings"
import "core:os"
import "core:mem/virtual"
import "core:log"

main :: proc() {
    arena : virtual.Arena
    context.allocator = virtual.arena_allocator(&arena)
    context.temp_allocator = context.allocator
    context.logger = log.create_console_logger()
    
    
    
}
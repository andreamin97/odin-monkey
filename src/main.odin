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

	buf: [1024]byte
	for {
		fmt.printf(">> ")
		n, err := os.read(os.stdin, buf[:])
		if err == nil {
			tokenizer := NewTokenizer(string(buf[:]), context.temp_allocator)
			tok := NextToken(tokenizer)
			for tok.type != .EOF {
				fmt.println(tok)
				tok = NextToken(tokenizer)
			}
		}
		else {
			fmt.eprintln("Couldn't read input:", err)
		}

		free_all(context.temp_allocator)
	}
}
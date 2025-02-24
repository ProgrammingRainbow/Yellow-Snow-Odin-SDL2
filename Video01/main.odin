package game

import "core:os"
import sdl "vendor:sdl2"

SDL_FLAGS :: sdl.INIT_EVERYTHING
RENDER_FLAGS :: sdl.RENDERER_ACCELERATED

WINDOW_TITLE :: "Don't Eat the Yellow Snow!"
WINDOW_WIDTH :: 800
WINDOW_HEIGHT :: 600

main :: proc() {
	exit_status := 1
	game: ^Game = nil

	defer os.exit(exit_status)
	defer game_cleanup(&game)

	if new_game(&game) {
		game_run(game)
		exit_status = 0

	}
}

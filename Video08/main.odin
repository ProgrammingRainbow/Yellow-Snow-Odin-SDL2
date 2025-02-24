package game

import "core:os"
import sdl "vendor:sdl2"
import img "vendor:sdl2/image"

SDL_FLAGS :: sdl.INIT_EVERYTHING
IMG_FLAGS :: img.INIT_PNG
RENDER_FLAGS :: sdl.RENDERER_ACCELERATED

WINDOW_TITLE :: "Don't Eat the Yellow Snow!"
WINDOW_WIDTH :: 800
WINDOW_HEIGHT :: 600

PLAYER_Y :: 377
PLAYER_LEFT_OFFSET :: 43
PLAYER_RIGHT_OFFSET :: 43
PLAYER_TOP_OFFSET :: 16
PLAYER_VEL :: 5

FLAKE_VEL :: 5
GROUND :: 550

FONT_SIZE :: 32
FONT_COLOR :: sdl.Color{255, 255, 255, 255}

main :: proc() {
	exit_status := 1
	game: ^Game = nil

	defer os.exit(exit_status)
	defer game_cleanup(&game)

	if new_game(&game) {
		if game_run(game) {
			exit_status = 0
		}
	}
}

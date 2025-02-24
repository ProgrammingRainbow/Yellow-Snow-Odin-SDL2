package game

import "core:fmt"
import sdl "vendor:sdl2"

Game :: struct {
	window:   ^sdl.Window,
	renderer: ^sdl.Renderer,
}

new_game :: proc(g: ^^Game) -> bool {
	g^ = new(Game)
	if g^ == nil {
		fmt.eprintfln("Error: Creating new Game instance.")
		return false
	}

	if !init_sdl(g^) {return false}

	return true
}

game_cleanup :: proc(g: ^^Game) {
	if g^ != nil {
		if g^.renderer != nil {
			sdl.DestroyRenderer(g^.renderer)
			g^.renderer = nil
		}
		if g^.window != nil {
			sdl.DestroyWindow(g^.window)
			g^.window = nil
		}

		sdl.Quit()

		free(g^)
		g^ = nil
	}

	fmt.println("All Clean!")
}

game_run :: proc(g: ^Game) {
	sdl.RenderClear(g.renderer)

	sdl.RenderPresent(g.renderer)

	sdl.Delay(5000)
}

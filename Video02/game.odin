package game

import "core:fmt"
import sdl "vendor:sdl2"

Game :: struct {
	window:   ^sdl.Window,
	renderer: ^sdl.Renderer,
	event:    sdl.Event,
	running:  bool,
}

new_game :: proc(g: ^^Game) -> bool {
	g^ = new(Game)
	if g^ == nil {
		fmt.eprintfln("Error: Creating new Game instance.")
		return false
	}

	if !init_sdl(g^) {return false}

	g^.running = true

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

game_event :: proc(g: ^Game) {
	for sdl.PollEvent(&g.event) {
		#partial switch g.event.type {
		case .QUIT:
			g.running = false
		case .KEYDOWN:
			#partial switch g.event.key.keysym.scancode {
			case .ESCAPE:
				g.running = false
			case:
			}
		}
	}
}

game_draw :: proc(g: ^Game) {
	sdl.RenderClear(g.renderer)

	sdl.RenderPresent(g.renderer)
}

game_run :: proc(g: ^Game) {
	for g.running {
		game_event(g)

		game_draw(g)

		sdl.Delay(16)
	}
}

package game

import "core:fmt"
import sdl "vendor:sdl2"
import img "vendor:sdl2/image"

Game :: struct {
	window:           ^sdl.Window,
	renderer:         ^sdl.Renderer,
	event:            sdl.Event,
	background_image: ^sdl.Texture,
	player:           ^Player,
	running:          bool,
}

new_game :: proc(g: ^^Game) -> bool {
	g^ = new(Game)
	if g^ == nil {
		fmt.eprintfln("Error: Creating new Game instance.")
		return false
	}

	if !init_sdl(g^) {return false}

	if !load_media(g^) {return false}

	if !player_new(&g^.player, g^.renderer) {return false}

	g^.running = true

	return true
}

game_cleanup :: proc(g: ^^Game) {
	if g^ != nil {
		player_cleanup(&g^.player)

		if g^.background_image != nil {sdl.DestroyTexture(g^.background_image)}

		if g^.renderer != nil {sdl.DestroyRenderer(g^.renderer)}
		if g^.window != nil {sdl.DestroyWindow(g^.window)}

		img.Quit()
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

	sdl.RenderCopy(g.renderer, g.background_image, nil, nil)

	player_draw(g.player)

	sdl.RenderPresent(g.renderer)
}

game_run :: proc(g: ^Game) {
	for g.running {
		game_event(g)

		game_draw(g)

		sdl.Delay(16)
	}
}

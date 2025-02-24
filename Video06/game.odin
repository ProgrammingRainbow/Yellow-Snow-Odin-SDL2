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
	white_image:      ^sdl.Texture,
	white_rect:       sdl.Rect,
	yellow_image:     ^sdl.Texture,
	yellow_rect:      sdl.Rect,
	flakes:           [dynamic]^Flake,
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

	for _ in 0 ..< 10 {
		flake: ^Flake = nil
		if !flake_new(&flake, g^.renderer, g^.white_image, g^.white_rect, true) {return false}
		append(&g^.flakes, flake)
	}

	for _ in 0 ..< 5 {
		flake: ^Flake = nil
		if !flake_new(&flake, g^.renderer, g^.yellow_image, g^.yellow_rect, false) {return false}
		append(&g^.flakes, flake)
	}

	g^.running = true

	return true
}

game_cleanup :: proc(g: ^^Game) {
	if g^ != nil {
		player_cleanup(&g^.player)

		for &flake in g^.flakes {
			flake_cleanup(&flake)
		}
		delete(g^.flakes)
		g^.flakes = [dynamic]^Flake{}

		if g^.yellow_image != nil {sdl.DestroyTexture(g^.yellow_image)}
		if g^.white_image != nil {sdl.DestroyTexture(g^.white_image)}
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

game_update :: proc(g: ^Game) {
	player_update(g.player)
}

game_draw :: proc(g: ^Game) {
	sdl.RenderClear(g.renderer)

	sdl.RenderCopy(g.renderer, g.background_image, nil, nil)

	player_draw(g.player)

	for flake in g.flakes {
		flake_draw(flake)
	}

	sdl.RenderPresent(g.renderer)
}

game_run :: proc(g: ^Game) {
	for g.running {
		game_event(g)

		game_update(g)

		game_draw(g)

		sdl.Delay(16)
	}
}

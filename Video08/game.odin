package game

import "core:fmt"
import sdl "vendor:sdl2"
import img "vendor:sdl2/image"
import ttf "vendor:sdl2/ttf"

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
	score:            ^Score,
	running:          bool,
	playing:          bool,
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

	if !score_new(&g^.score, g^.renderer) {return false}

	g^.running = true
	g^.playing = true

	return true
}

game_cleanup :: proc(g: ^^Game) {
	if g^ != nil {
		score_cleanup(&g^.score)
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

		ttf.Quit()
		img.Quit()
		sdl.Quit()

		free(g^)
		g^ = nil
	}

	fmt.println("All Clean!")
}

check_collision :: proc(g: ^Game, f: ^Flake) -> bool {
	if flake_bottom(f) > player_top(g.player) {
		if flake_right(f) > player_left(g.player) {
			if flake_left(f) < player_right(g.player) {
				if flake_white(f) {
					if !score_increment(g.score) {return false}
					flake_reset(f, false)
				} else {
					g.playing = false
				}
			}
		}
	}

	return true
}

game_reset :: proc(g: ^Game) -> bool {
	if !g.playing {
		g.playing = true

		for flake in g.flakes {
			flake_reset(flake, true)
		}

		if !score_reset(g.score) {return false}
	}

	return true
}

game_event :: proc(g: ^Game) -> bool {
	for sdl.PollEvent(&g.event) {
		#partial switch g.event.type {
		case .QUIT:
			g.running = false
		case .KEYDOWN:
			#partial switch g.event.key.keysym.scancode {
			case .ESCAPE:
				g.running = false
			case .SPACE:
				if !game_reset(g) {return false}
			case:
			}
		}
	}

	return true
}

game_update :: proc(g: ^Game) -> bool {
	if g.playing {
		player_update(g.player)

		for flake in g.flakes {
			flake_update(flake)
			if !check_collision(g, flake) {return false}
		}
	}

	return true
}

game_draw :: proc(g: ^Game) {
	sdl.RenderClear(g.renderer)

	sdl.RenderCopy(g.renderer, g.background_image, nil, nil)

	player_draw(g.player)

	for flake in g.flakes {
		flake_draw(flake)
	}

	score_draw(g.score)

	sdl.RenderPresent(g.renderer)
}

game_run :: proc(g: ^Game) -> bool {
	for g.running {
		if !game_event(g) {return false}

		if !game_update(g) {return false}

		game_draw(g)

		sdl.Delay(16)
	}

	return true
}

package game

import "core:fmt"
import sdl "vendor:sdl2"
import img "vendor:sdl2/image"
import mix "vendor:sdl2/mixer"

load_media :: proc(g: ^Game) -> bool {
	g.background_image = img.LoadTexture(g.renderer, "images/background.png")
	if g.background_image == nil {
		fmt.eprintfln("Error loading Texture: %s", img.GetError())
		return false
	}

	g.white_image = img.LoadTexture(g.renderer, "images/white.png")
	if g.white_image == nil {
		fmt.eprintfln("Error loading Texture: %s", img.GetError())
		return false
	}

	if sdl.QueryTexture(g.white_image, nil, nil, &g.white_rect.w, &g.white_rect.h) != 0 {
		fmt.eprintfln("Error querying Texture: %s", sdl.GetError())
		return false
	}

	g.yellow_image = img.LoadTexture(g.renderer, "images/yellow.png")
	if g.yellow_image == nil {
		fmt.eprintfln("Error loading Texture: %s", img.GetError())
		return false
	}

	if sdl.QueryTexture(g.yellow_image, nil, nil, &g.yellow_rect.w, &g.yellow_rect.h) != 0 {
		fmt.eprintfln("Error querying Texture: %s", sdl.GetError())
		return false
	}

	g.hit_sound = mix.LoadWAV("sounds/hit.ogg")
	if g.hit_sound == nil {
		fmt.eprintfln("Error loading Chunk: %s", mix.GetError())
		return false
	}

	g.collect_sound = mix.LoadWAV("sounds/collect.ogg")
	if g.collect_sound == nil {
		fmt.eprintfln("Error loading Chunk: %s", mix.GetError())
		return false
	}

	g.music = mix.LoadMUS("music/winter_loop.ogg")
	if g.music == nil {
		fmt.eprintfln("Error loading Music: %s", mix.GetError())
		return false
	}

	return true
}

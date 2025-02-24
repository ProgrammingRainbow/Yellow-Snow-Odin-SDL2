package game

import "core:fmt"
import sdl "vendor:sdl2"
import img "vendor:sdl2/image"

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

	return true
}

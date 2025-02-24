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

	return true
}

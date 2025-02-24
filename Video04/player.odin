package game

import "core:fmt"
import sdl "vendor:sdl2"
import img "vendor:sdl2/image"

Player :: struct {
	renderer: ^sdl.Renderer,
	image:    ^sdl.Texture,
	rect:     sdl.Rect,
}

player_new :: proc(p: ^^Player, renderer: ^sdl.Renderer) -> bool {
	p^ = new(Player)
	if p^ == nil {
		fmt.eprintfln("Error: Creating new Sprite instance.")
		return false
	}

	p^.renderer = renderer

	p^.image = img.LoadTexture(p^.renderer, "images/player.png")
	if p^.image == nil {
		fmt.eprintfln("Error loading Texture: %s", img.GetError())
		return false
	}

	if sdl.QueryTexture(p^.image, nil, nil, &p^.rect.w, &p^.rect.h) != 0 {
		fmt.eprintfln("Error querying Texture: %s", sdl.GetError())
		return false
	}

	p^.rect.x = (WINDOW_WIDTH - p^.rect.w) / 2
	p^.rect.y = PLAYER_Y

	return true
}

player_cleanup :: proc(p: ^^Player) {
	if p^ != nil {
		if p^.image != nil {sdl.DestroyTexture(p^.image)}

		free(p^)
		p^ = nil
	}

	fmt.println("Player clean.")
}

player_draw :: proc(p: ^Player) {
	sdl.RenderCopy(p.renderer, p.image, nil, &p.rect)
}

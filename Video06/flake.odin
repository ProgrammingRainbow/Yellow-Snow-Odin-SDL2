package game

import "core:fmt"
import "core:math/rand"
import sdl "vendor:sdl2"

Flake :: struct {
	renderer: ^sdl.Renderer,
	image:    ^sdl.Texture,
	rect:     sdl.Rect,
	is_white: bool,
}

flake_new :: proc(
	f: ^^Flake,
	renderer: ^sdl.Renderer,
	image: ^sdl.Texture,
	rect: sdl.Rect,
	is_white: bool,
) -> bool {
	f^ = new(Flake)
	if f^ == nil {
		fmt.eprintfln("Error: Creating new Flake instance.")
		return false
	}

	f^.renderer = renderer
	f^.image = image
	f^.rect = rect
	f^.is_white = is_white

	flake_reset(f^)

	return true
}

flake_cleanup :: proc(f: ^^Flake) {
	if f^ != nil {
		free(f^)
		f^ = nil
	}

	fmt.println("Flake clean.")
}

flake_reset :: proc(f: ^Flake) {
	f.rect.x = rand.int31_max(WINDOW_WIDTH - f.rect.w)
	f.rect.y = rand.int31_max(WINDOW_HEIGHT - f.rect.h)
}

flake_draw :: proc(f: ^Flake) {
	sdl.RenderCopy(f.renderer, f.image, nil, &f.rect)
}

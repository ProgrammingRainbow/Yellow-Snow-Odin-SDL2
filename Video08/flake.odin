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

	flake_reset(f^, true)

	return true
}

flake_cleanup :: proc(f: ^^Flake) {
	if f^ != nil {
		free(f^)
		f^ = nil
	}

	fmt.println("Flake clean.")
}

flake_reset :: proc(f: ^Flake, full: bool) {
	height: i32 = full ? WINDOW_HEIGHT * 2 : WINDOW_HEIGHT

	f.rect.x = rand.int31_max(WINDOW_WIDTH - f.rect.w)
	f.rect.y = -f.rect.h - rand.int31_max(height)
}

flake_left :: proc(f: ^Flake) -> i32 {return f.rect.x}

flake_right :: proc(f: ^Flake) -> i32 {return f.rect.x + f.rect.w}

flake_bottom :: proc(f: ^Flake) -> i32 {return f.rect.y + f.rect.h}

flake_white :: proc(f: ^Flake) -> bool {return f.is_white}

flake_update :: proc(f: ^Flake) {
	f.rect.y += FLAKE_VEL
	if flake_bottom(f) > GROUND {
		flake_reset(f, false)
	}
}

flake_draw :: proc(f: ^Flake) {
	sdl.RenderCopy(f.renderer, f.image, nil, &f.rect)
}

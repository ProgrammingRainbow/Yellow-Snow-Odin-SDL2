package game

import "core:fmt"
import sdl "vendor:sdl2"
import img "vendor:sdl2/image"

Player :: struct {
	renderer: ^sdl.Renderer,
	image:    ^sdl.Texture,
	rect:     sdl.Rect,
	x_pos:    f64,
	keystate: [^]u8,
	flip:     sdl.RendererFlip,
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
	p^.x_pos = f64(p^.rect.x)
	p^.rect.y = PLAYER_Y
	p^.flip = sdl.RendererFlip.NONE

	p^.keystate = sdl.GetKeyboardState(nil)

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

player_left :: proc(p: ^Player) -> i32 {return p.rect.x + PLAYER_LEFT_OFFSET}

player_right :: proc(p: ^Player) -> i32 {return p.rect.x + p.rect.w - PLAYER_RIGHT_OFFSET}

player_top :: proc(p: ^Player) -> i32 {return p.rect.y + PLAYER_TOP_OFFSET}

player_update :: proc(p: ^Player, dt: f64) {
	if p.keystate[sdl.Scancode.A] == 1 || p.keystate[sdl.Scancode.LEFT] == 1 {
		p.x_pos -= PLAYER_VEL * dt
		p.rect.x = i32(p.x_pos)
		if player_left(p) < 0 {
			p.rect.x = -PLAYER_LEFT_OFFSET
			p.x_pos = -PLAYER_LEFT_OFFSET
		}
		p.flip = sdl.RendererFlip.HORIZONTAL
	}
	if p.keystate[sdl.Scancode.D] == 1 || p.keystate[sdl.Scancode.RIGHT] == 1 {
		p.x_pos += PLAYER_VEL * dt
		p.rect.x = i32(p.x_pos)
		if player_right(p) > WINDOW_WIDTH {
			p.rect.x = WINDOW_WIDTH - p.rect.w + PLAYER_RIGHT_OFFSET
			p.x_pos = f64(p.rect.x)
		}
		p.flip = sdl.RendererFlip.NONE
	}
}

player_draw :: proc(p: ^Player) {
	sdl.RenderCopyEx(p.renderer, p.image, nil, &p.rect, 0, nil, p.flip)
}

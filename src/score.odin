package game

import "core:fmt"
import sdl "vendor:sdl2"
import img "vendor:sdl2/image"
import ttf "vendor:sdl2/ttf"

Score :: struct {
	renderer: ^sdl.Renderer,
	font:     ^ttf.Font,
	surface:  ^sdl.Surface,
	image:    ^sdl.Texture,
	rect:     sdl.Rect,
	score:    u32,
}

score_new :: proc(s: ^^Score, renderer: ^sdl.Renderer) -> bool {
	s^ = new(Score)
	if s^ == nil {
		fmt.eprintfln("Error: Creating new Score instance.")
		return false
	}

	s^.renderer = renderer
	s^.rect.x = 10
	s^.rect.y = 10

	s^.font = ttf.OpenFont("fonts/freesansbold.ttf", FONT_SIZE)
	if s^.font == nil {
		fmt.eprintfln("Error opening Font: %s", ttf.GetError())
		return false
	}

	if !score_reset(s^) {return false}

	return true
}

score_cleanup :: proc(s: ^^Score) {
	if s^ != nil {
		if s^.font != nil {ttf.CloseFont(s^.font)}
		if s^.surface != nil {sdl.FreeSurface(s^.surface)}
		if s^.image != nil {sdl.DestroyTexture(s^.image)}

		free(s^)
		s^ = nil
	}

	fmt.println("Score clean.")
}

score_update :: proc(s: ^Score) -> bool {
	if s.surface != nil {
		sdl.FreeSurface(s.surface)
		s.surface = nil
	}

	if s.image != nil {
		sdl.DestroyTexture(s.image)
		s.image = nil
	}

	score_text := fmt.ctprint("Score: ", s.score)

	s.surface = ttf.RenderText_Blended(s.font, score_text, FONT_COLOR)
	if s.surface == nil {
		fmt.eprintfln("Error creating text Surface: %s", ttf.GetError())
		return false
	}

	s.image = sdl.CreateTextureFromSurface(s.renderer, s.surface)
	if s.image == nil {
		fmt.eprintfln("Error creating Texture from Surface: %s", sdl.GetError())
		return false
	}

	if sdl.QueryTexture(s.image, nil, nil, &s.rect.w, &s.rect.h) != 0 {
		fmt.eprintfln("Error querying Texture: %s", sdl.GetError())
		return false
	}

	return true
}

score_reset :: proc(s: ^Score) -> bool {
	s.score = 0

	if !score_update(s) {return false}

	return true
}

score_increment :: proc(s: ^Score) -> bool {
	s.score += 1

	if !score_update(s) {return false}

	return true
}

score_draw :: proc(s: ^Score) {
	sdl.RenderCopy(s.renderer, s.image, nil, &s.rect)
}

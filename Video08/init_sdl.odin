package game

import "core:fmt"
import sdl "vendor:sdl2"
import img "vendor:sdl2/image"
import ttf "vendor:sdl2/ttf"

init_sdl :: proc(g: ^Game) -> bool {
	if sdl.Init(SDL_FLAGS) != 0 {
		fmt.eprintfln("Error initializing SDL2: %s", sdl.GetError())
		return false
	}

	if (img.Init(IMG_FLAGS) & IMG_FLAGS) != IMG_FLAGS {
		fmt.eprintfln("Error initializing SDL2_image: %s", img.GetError())
		return false
	}

	if ttf.Init() != 0 {
		fmt.eprintfln("Error initializing SDL2_TTF: %s", ttf.GetError())
		return false
	}

	g.window = sdl.CreateWindow(
		WINDOW_TITLE,
		sdl.WINDOWPOS_CENTERED,
		sdl.WINDOWPOS_CENTERED,
		WINDOW_WIDTH,
		WINDOW_HEIGHT,
		nil,
	)
	if g.window == nil {
		fmt.eprintfln("Error creating Window: %s", sdl.GetError())
		return false
	}

	g.renderer = sdl.CreateRenderer(g.window, -1, RENDER_FLAGS)
	if g.renderer == nil {
		fmt.eprintfln("Error creating Renderer: %s", sdl.GetError())
		return false
	}

	icon_surf := img.Load("images/yellow.png")
	if icon_surf == nil {
		fmt.eprintfln("Error loading Surface: %s", img.GetError())
		return false
	}
	sdl.SetWindowIcon(g.window, icon_surf)
	sdl.FreeSurface(icon_surf)

	return true
}

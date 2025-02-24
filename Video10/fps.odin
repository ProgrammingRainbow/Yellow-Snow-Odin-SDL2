package game

import "core:time"
import "core:fmt"

Fps :: struct {
    target_duration: time.Duration,
    carry_delay: time.Duration,
    max_duration: time.Duration,
    last_time: time.Time,
    fps_display: bool,
    fps_counter: int,
    fps_last_time: time.Time,
    dt: f64,
}

fps_new :: proc(f: ^^Fps) -> bool {
	f^ = new(Fps)
	if f^ == nil {
		fmt.eprintfln("Error: Creating new FPS instance.")
		return false
	}

    f^.target_duration = time.Second / TARGET_FPS
    f^.carry_delay = 0
    f^.max_duration = time.Second / 20
    f^.last_time = time.now()
    f^.fps_display = false
    f^.fps_counter = 0
    f^.fps_last_time = time.now()
    f^.dt = 0

    return true
}

fps_cleanup :: proc(f: ^^Fps) {
	if f^ != nil {
		free(f^)
		f^ = nil
	}

	fmt.println("Fps clean.")
}

fps_toggle :: proc(f: ^Fps) {
    if f.fps_display {
        f.fps_display = false;
    } else {
        f.fps_display = true;
        f.fps_counter = 0;
        f.fps_last_time = time.now()
    }
}

fps_update :: proc(f: ^Fps) -> f64 {
    current_time := time.now()
    first_elapsed := time.diff(current_time, f.last_time)
    sleep_duration := f.target_duration - first_elapsed + f.carry_delay

    if sleep_duration > 0 {
        time.sleep(sleep_duration)
    }

    current_time = time.now()
    second_elapsed := time.diff(f.last_time, current_time)

    f.dt = f64(second_elapsed) / f64(time.Second)
    f.carry_delay = f.target_duration - second_elapsed + f.carry_delay

    if f.carry_delay > f.max_duration {
        f.carry_delay = f.max_duration
    }
    if f.carry_delay < -f.max_duration {
        f.carry_delay = -f.max_duration
    }

    f.last_time = current_time

    if f.fps_display {
        f.fps_counter += 1
        //fmt.printfln("time.diff %d", time.diff(current_time, f.fps_last_time))
        if time.diff(f.fps_last_time, current_time) > time.Second {
            fmt.printf("FPS: %d\n", f.fps_counter)
            f.fps_counter = 0
            f.fps_last_time = time.time_add(f.fps_last_time, time.Second)
        }
    }

    return f.dt
}


var t = get_timer();

mouse_left = mouse_check_button(mb_left);
mouse_right = mouse_check_button(mb_right);
mouse_middle = mouse_check_button(mb_middle);
wasd = keyboard_check(ord("A")) || keyboard_check(ord("S")) | keyboard_check(ord("D")) | keyboard_check(ord("W")) ||
    keyboard_check(vk_down) || keyboard_check(vk_left) | keyboard_check(vk_right) | keyboard_check(vk_up);

press_left = mouse_check_button_pressed(mb_left);
press_right = mouse_check_button_pressed(mb_right);
press_middle = mouse_check_button_pressed(mb_middle);
release_wasd = keyboard_check_pressed(ord("A")) || keyboard_check_pressed(ord("S")) | keyboard_check_pressed(ord("D")) | keyboard_check_pressed(ord("W")) ||
    keyboard_check_pressed(vk_down) || keyboard_check_pressed(vk_left) | keyboard_check_pressed(vk_right) | keyboard_check_pressed(vk_up);

release_left = mouse_check_button_released(mb_left);
release_right = mouse_check_button_released(mb_right);
release_middle = mouse_check_button_released(mb_middle);
release_wasd = keyboard_check_released(ord("A")) || keyboard_check_released(ord("S")) | keyboard_check_released(ord("D")) | keyboard_check_released(ord("W")) ||
    keyboard_check_released(vk_down) || keyboard_check_released(vk_left) | keyboard_check_released(vk_right) | keyboard_check_released(vk_up);

double_left = false;
double_right = false;
double_middle = false;
double_wasd = false;

if (press_left) {
    if ((t - last_time_left) < double_click_threshold) {
        double_left = true;
    }
    time_left = t;
    last_time_left = t;
}
if (press_right) {
    if ((t - last_time_right) < double_click_threshold) {
        double_right = true;
    }
    time_right = t;
    last_time_right = t;
}
if (press_middle) {
    if ((t - last_time_middle) < double_click_threshold) {
        double_middle = true;
    }
    time_middle = t;
    last_time_middle = t;
}
if (press_wasd) {
    if ((t - last_time_wasd) < double_click_threshold) {
        double_wasd = true;
    }
    time_wasd = t;
    last_time_wasd = t;
}

time_wasd_seconds = max(0, t - last_time_wasd);

if (release_left) {
    time_left = -1;
}
if (release_right) {
    time_right = -1;
}
if (release_middle) {
    time_middle = -1;
}
if (release_wasd) {
    time_wasd = -1;
    time_wasd_seconds = -1;
}

escape = keyboard_check(vk_escape);
press_escape = keyboard_check_pressed(vk_escape);
release_escape = keyboard_check_released(vk_escape);

help = keyboard_check(key_help) || mouse_check_button(mb_middle);
press_help = keyboard_check_pressed(key_help) || mouse_check_button_pressed(mb_middle);
release_help = keyboard_check_released(key_help) || mouse_check_button_released(mb_middle);
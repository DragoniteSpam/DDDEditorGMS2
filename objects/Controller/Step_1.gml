var t = get_timer();

mouse_left = mouse_check_button(mb_left);
mouse_right = mouse_check_button(mb_right);
mouse_middle = mouse_check_button(mb_middle);

press_left = mouse_check_button_pressed(mb_left);
press_right = mouse_check_button_pressed(mb_right);
press_middle = mouse_check_button_pressed(mb_middle);

release_left = mouse_check_button_released(mb_left);
release_right = mouse_check_button_released(mb_right);
release_middle = mouse_check_button_released(mb_middle);

double_left = false;
double_right = false;
double_middle = false;

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

if (release_left) {
    time_left = -1;
}
if (release_right) {
    time_right = -1;
}
if (release_middle) {
    time_middle = -1;
}

escape = keyboard_check(vk_escape);
press_escape = keyboard_check_pressed(vk_escape);
release_escape = keyboard_check_released(vk_escape);

help = keyboard_check(key_help) || mouse_check_button(mb_middle);
press_help = keyboard_check_pressed(key_help) || mouse_check_button_pressed(mb_middle);
release_help = keyboard_check_released(key_help) || mouse_check_button_released(mb_middle);
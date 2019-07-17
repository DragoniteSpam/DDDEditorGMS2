mouse_left = mouse_check_button(mb_left);
mouse_right = mouse_check_button(mb_right);
mouse_middle = mouse_check_button(mb_middle);

press_left = mouse_check_button_pressed(mb_left);
press_right = mouse_check_button_pressed(mb_right);
press_middle = mouse_check_button_pressed(mb_middle);

release_left = mouse_check_button_released(mb_left);
release_right = mouse_check_button_released(mb_right);
release_middle = mouse_check_button_released(mb_middle);

if (press_left) {
    time_left = get_timer();
}
if (press_right) {
    time_right = get_timer();
}
if (press_middle) {
    time_middle = get_timer();
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
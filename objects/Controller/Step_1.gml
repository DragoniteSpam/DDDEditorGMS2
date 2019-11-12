var t = get_timer();

var last_wasd = wasd;

mouse_left = mouse_check_button(mb_left);
mouse_right = mouse_check_button(mb_right);
mouse_middle = mouse_check_button(mb_middle);
wasd = keyboard_check(ord("A")) || keyboard_check(ord("S")) || keyboard_check(ord("D")) || keyboard_check(ord("W")) ||
    keyboard_check(vk_down) || keyboard_check(vk_left) || keyboard_check(vk_right) || keyboard_check(vk_up);

press_left = mouse_check_button_pressed(mb_left);
press_right = mouse_check_button_pressed(mb_right);
press_middle = mouse_check_button_pressed(mb_middle);
press_wasd = wasd && !last_wasd;

release_left = mouse_check_button_released(mb_left);
release_right = mouse_check_button_released(mb_right);
release_middle = mouse_check_button_released(mb_middle);
release_wasd = last_wasd && !wasd;

double_left = false;
double_right = false;
double_middle = false;
double_wasd = false;

if (press_left) {
    if ((t - time_left) < double_click_threshold) double_left = true;
    time_left = t;
}
if (press_right) {
    if ((t - time_right) < double_click_threshold) double_right = true;
    time_right = t;
}
if (press_middle) {
    if ((t - time_middle) < double_click_threshold) double_middle = true;
    time_middle = t;
}
if (press_wasd) {
    time_wasd = t;
}

time_wasd_seconds = (t - time_wasd) / MILLION;

if (release_left) time_left = -1;
if (release_right) time_right = -1;
if (release_middle) time_middle = -1;
if (release_wasd) time_wasd = -1;

if (!wasd) time_wasd_seconds = -1;

escape = keyboard_check(vk_escape);
press_escape = keyboard_check_pressed(vk_escape);
release_escape = keyboard_check_released(vk_escape);

help = keyboard_check(key_help) || mouse_check_button(mb_middle);
press_help = keyboard_check_pressed(key_help) || mouse_check_button_pressed(mb_middle);
release_help = keyboard_check_released(key_help) || mouse_check_button_released(mb_middle);
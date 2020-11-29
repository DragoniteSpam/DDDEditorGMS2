if (ignore_next--) {
    mouse_left = false;
    mouse_right = false;
    mouse_middle = false;
    wasd = false;
    enter = false;
    
    press_left = false;
    press_right = false;
    press_middle = false;
    press_wasd = false;
    press_enter = false;
    
    release_left = false;
    release_right = false;
    release_middle = false;
    release_wasd = false;
    release_enter = false;
    
    double_left = false;
    double_right = false;
    double_middle = false;
    double_wasd = false;
    double_enter = false;
    exit;
}

var t = get_timer();

var last_wasd = wasd;

mouse_left = mouse_check_button(mb_left);
mouse_right = mouse_check_button(mb_right);
mouse_middle = mouse_check_button(mb_middle);
wasd = keyboard_check(ord("A")) || keyboard_check(ord("S")) || keyboard_check(ord("D")) || keyboard_check(ord("W")) ||
    keyboard_check(vk_down) || keyboard_check(vk_left) || keyboard_check(vk_right) || keyboard_check(vk_up);
enter = keyboard_check(vk_enter);

press_left = mouse_check_button_pressed(mb_left);
press_right = mouse_check_button_pressed(mb_right);
press_middle = mouse_check_button_pressed(mb_middle);
press_wasd = wasd && !last_wasd;
press_enter = keyboard_check_pressed(vk_enter);

release_left = mouse_check_button_released(mb_left);
release_right = mouse_check_button_released(mb_right);
release_middle = mouse_check_button_released(mb_middle);
release_wasd = last_wasd && !wasd;
release_enter = keyboard_check_released(vk_enter);

if (Stuff.settings.config.alternate_middle) {
    mouse_middle = mouse_middle || (keyboard_check(vk_control) && keyboard_check(vk_space));
    press_middle = press_middle || (keyboard_check_pressed(vk_control) && keyboard_check_pressed(vk_space));
    release_middle = release_middle || (keyboard_check_released(vk_control) && keyboard_check_released(vk_space));
}

double_left = false;
double_right = false;
double_middle = false;
double_wasd = false;
double_enter = false;

if (press_left) {
    if ((t - last_time_left) < double_click_threshold) double_left = true;
    time_left = t;
    last_time_left = t;
}
if (press_right) {
    if ((t - last_time_right) < double_click_threshold) double_right = true;
    time_right = t;
    last_time_right = t;
}
if (press_middle) {
    if ((t - last_time_middle) < double_click_threshold) double_middle = true;
    time_middle = t;
    last_time_middle = t;
}
if (press_wasd) {
    if ((t - last_time_wasd) < double_click_threshold) double_wasd = true;
    time_wasd = t;
    last_time_wasd = t;
}

time_wasd_seconds = (t - time_wasd) / MILLION;

if (press_enter) {
    if ((t - last_time_enter) < double_click_threshold) double_enter = true;
    time_enter = t;
    last_time_enter = t;
}

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

tab = keyboard_check(vk_tab);
press_tab = keyboard_check_pressed(vk_tab);
release_tab = keyboard_check_released(vk_tab);

mouse_x_delta = mouse_x - mouse_x_previous;
mouse_y_delta = mouse_y - mouse_y_previous;
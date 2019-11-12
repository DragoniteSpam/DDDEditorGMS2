mouse_left = false;
mouse_right = false;
mouse_middle = false;
wasd = false;

press_left = false;
press_right = false;
press_middle = false;
press_wasd = false;

release_left = false;
release_right = false;
release_middle = false;
release_wasd = false;

double_left = false;
double_right = false;
double_middle = false;

// for measuring click duration
time_left = -1;
time_right = -1;
time_middle = -1;
time_wasd = -1;
time_wasd_seconds = -1;

// special keys that get special treatment
escape = false;
press_escape = false;
release_escape = false;

help = false;
press_help = false;
release_help = false;

// hotkeys
key_help = vk_f1;

// mouse delta
mouse_x_previous = mouse_x;
mouse_y_previous = mouse_y;

double_click_threshold = 0.25 * MILLION;

// inputs; maybe these can be rebound though a menu, but that's not important now

input_selection_add = vk_control;
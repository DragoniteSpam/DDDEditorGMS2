function debug_timer_start() {
    __debug_time_manage("start");
}

function debug_timer_finish() {
    return __debug_time_manage("finish");
}

function __debug_time_manage(action) {
    static t = undefined;
    switch (action) {
        case "start": t = get_timer(); break;
        case "finish": if (t != undefined) return string((get_timer() - t) / 1000) + " ms";
    }
    return "";
}
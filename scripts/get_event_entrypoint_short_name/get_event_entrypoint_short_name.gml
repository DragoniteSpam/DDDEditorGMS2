/// @param DataEventNode

var entrypoint = argument0;
var event_name = entrypoint.event.name;
var entrypoint_name = entrypoint.name;
var event_length = string_length(event_name);
var entrypoint_length = string_length(entrypoint_name);
var max_length = 12;

return string_copy(event_name, 1, min(max_length, event_length)) + ((event_length > max_length) ? "..." : "") + "/" +
    string_copy(entrypoint_name, 1, min(max_length, entrypoint_length)) + ((entrypoint_length > max_length) ? "..." : "");
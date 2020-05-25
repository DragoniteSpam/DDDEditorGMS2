/// @param UIList
/// @param index

var list = argument0;
var index = argument1;
var emitter = list.entries[| index];

var text = emitter.name;

if (!emitter.streaming) {
    text = "(" + text + ")";
}

return text;
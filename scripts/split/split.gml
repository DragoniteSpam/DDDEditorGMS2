/// @param string
/// @param [delimiter]

var base = argument[0];
var delimiter = (argument_count > 1) ? argument[1] : " ";
var enqueue_delimiter = (argument_count > 2) ? argument[2] : false;
var enqueue_blank = (argument_count > 3) ? argument[3] : false;

var queue = ds_queue_create();
var tn = "";

base = base + string_char_at(delimiter, 1);         // lazy way of ensuring the last term in the list does not get skipped

for (var i = 1; i <= string_length(base); i++) {
    var c = string_char_at(base, i);
    var previous = string_char_at(base, i - 1);
    var is_break_char = false;
    for (var j = 1; j <= string_length(delimiter); j++) {
        if (string_char_at(delimiter, j) == c && previous != "\\") {
            if (string_length(tn) > 0 || enqueue_blank) {
                ds_queue_enqueue(queue, tn);
            }
            if (enqueue_delimiter) {
                ds_queue_enqueue(queue, string_char_at(delimiter, j));
            }
            tn = "";
            is_break_char = true;
            break;
        }
    }
    if (!is_break_char) {
        tn = tn + c;
    }
}

// because i did a dumb way of adding the first term
if (ds_queue_size(queue) == 1 && string_length(ds_queue_head(queue)) == 0) {
    ds_queue_clear(queue);
}

return queue;
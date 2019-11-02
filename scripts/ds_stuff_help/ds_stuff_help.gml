/// @param [file]

var where = (argument_count > 0) ? argument[0] : "Overview";

/*
 * almost the same thing as ds_stuff_open, but it specifically targets the help file
 * and opens it to a specific page. same return/error codes as ds_stuff_open. the
 * parameter here is the page to open to, defaulting to the Overview page if you
 * don't specify
 */

return external_call(global._ds_stuff_help, where);
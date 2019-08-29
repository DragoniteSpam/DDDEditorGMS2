// Takes any number of arguments but doesn't do anything, good for when you
// might need a placeholder script. this one also shows the call stack.
// Note: it won't take arguments if called by its name, because it then thinks
// it's supposed to ask for zero arguments. It will take (and eat) arguments
// if called with script_execute, though.

show_error(@"Stack trace requested, probably in lieu of a NotImplementedException.
(If you're an end user and seeing this, that means the developer meant to add a
feature and probably forgot.)
", false);
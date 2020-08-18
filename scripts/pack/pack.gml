/// @param bool0...
function pack() {
	// if not all of the arguments are booleans, bad things will happen
	// i don't know why you'd try and put more than 32 values in here but it'll
	// stop trying after 32

	var n = 0;

	if (argument_count >= 24) {
	    show_error("You seem to be trying to pack more than 23 bools into a single value;\ndue to the way floating point works, that probably won't do what you want it to do. Sorry.", true);
	}

	for (var i = 0; i < min(argument_count, 23); i++) {
	    n = n | (argument[i] << i);
	}

	return n;


}

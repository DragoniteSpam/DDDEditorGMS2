/// @param bool0...
function pack() {
	var n = 0;

	if (argument_count >= 24) {
	    throw "You seem to be trying to pack more than 23 bools into a single value;\ndue to the way floating point works, that probably won't do what you want it to do. Sorry.";
	}

	for (var i = 0; i < min(argument_count, 23); i++) {
	    n = n | (argument[i] << i);
	}

	return n;
}

function unpack(field, n) {
	return !!(field & (1 << n));
}
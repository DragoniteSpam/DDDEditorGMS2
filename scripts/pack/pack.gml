/// @param bool0...
// if not all of the arguments are booleans, bad things will happen
// i don't know why you'd try and put more than 32 values in here but it'll
// stop trying after 32

var n = 0;

for (var i = 0; i < min(argument_count, 32); i++) {
    n = n | (argument[i] << i);
}

return n;
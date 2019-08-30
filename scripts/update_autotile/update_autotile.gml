/// @param EntityAutotile

// these aren't evaluations, so you actually need the explicit checks against noone here
// otherwise you'll just bitshift the instance ID which won't work
var value = (argument0.neighbors[0] != noone) << 0 |
    (argument0.neighbors[1] != noone) << 1 |
    (argument0.neighbors[2] != noone) << 2 |
    (argument0.neighbors[3] != noone) << 3 |
    (argument0.neighbors[4] != noone) << 4 |
    (argument0.neighbors[5] != noone) << 5 |
    (argument0.neighbors[6] != noone) << 6 |
    (argument0.neighbors[7] != noone) << 7;

not_yet_implemented();

/*
 * * * * *
 * 0 1 2 *
 * 3   4 *
 * 5 6 7 *
 * * * * *
 */
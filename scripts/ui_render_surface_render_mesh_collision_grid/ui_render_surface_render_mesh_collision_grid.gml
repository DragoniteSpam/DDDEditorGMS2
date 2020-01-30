/// @param UIRenderSurface
/// @param x1
/// @param y1
/// @param x2
/// @param y2

var surface = argument0;
var x1 = argument1;
var y1 = argument2;
var x2 = argument3;
var y2 = argument4;

var mesh = surface.root.mesh;

draw_clear_alpha(c_white, 1);

// grid size - cells must be square, and the longest dimension must fit on the render surface
var hcount = mesh.xmax - mesh.xmin;
var vcount = mesh.ymax - mesh.ymin;
var hstep = (x2 - x1) / max(hcount, 1);
var vstep = (y2 - y1) / max(vcount, 1);
hstep = min(hstep, vstep);
vstep = hstep;

// draw the grid - the last line should be at -1 so that it doesn't fall off the edge of the render surface
for (var i = 0; i <= hcount; i++) {
    var off = (i == hcount) ? 1 : 0;
    draw_line(i * hstep - off, 0, i * hstep - off, vcount * vstep);
}
for (var i = 0; i <= vcount; i++) {
    var off = (i == vcount) ? 1 : 0;
    draw_line(0, i * vstep - off, hcount * hstep, i * vstep - off);
}

var xx = surface.root.xx;
var yy = surface.root.yy;

draw_sprite(spr_star, 0, (xx + 0.5) * hstep, (yy + 0.5) * vstep);
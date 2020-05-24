/// @param ParticleEmitter

var emitter = argument0;

var x1 = min(emitter.region_x1, emitter.region_x2);
var y1 = min(emitter.region_y1, emitter.region_y2);
var x2 = max(emitter.region_x1, emitter.region_x2);
var y2 = max(emitter.region_y1, emitter.region_y2);
var xc = mean(x1, x2);
var yc = mean(y1, y2);
var xtex1 = x1 / sprite_get_width(b_tileset_checkers);
var ytex1 = y1 / sprite_get_height(b_tileset_checkers);
var xtex2 = x2 / sprite_get_width(b_tileset_checkers);
var ytex2 = y2 / sprite_get_height(b_tileset_checkers);
var xtexc = mean(xtex1, xtex2);
var ytexc = mean(ytex1, ytex2);
var ao = (emitter.region_distribution == PartEmitterDistributions.GAUSSIAN) ? 0 : 0.125;
var ac = (emitter.region_distribution == PartEmitterDistributions.INVGAUSSIAN) ? 0 : 0.125;

vertex_begin(emitter.region, Stuff.graphics.vertex_format_basic);
switch (emitter.region_shape) {
    case PartEmitterShapes.RECTANGLE:
        vertex_point_basic(emitter.region, xc, yc, 0, 0, 0, 1, xtexc, ytexc, c_white, ac);
        vertex_point_basic(emitter.region, x1, y1, 0, 0, 0, 1, xtex1, ytex1, c_white, ao);
        vertex_point_basic(emitter.region, x2, y1, 0, 0, 0, 1, xtex2, ytex1, c_white, ao);
        vertex_point_basic(emitter.region, xc, yc, 0, 0, 0, 1, xtexc, ytexc, c_white, ac);
        vertex_point_basic(emitter.region, x2, y1, 0, 0, 0, 1, xtex2, ytex1, c_white, ao);
        vertex_point_basic(emitter.region, x2, y2, 0, 0, 0, 1, xtex2, ytex2, c_white, ao);
        vertex_point_basic(emitter.region, xc, yc, 0, 0, 0, 1, xtexc, ytexc, c_white, ac);
        vertex_point_basic(emitter.region, x2, y2, 0, 0, 0, 1, xtex2, ytex2, c_white, ao);
        vertex_point_basic(emitter.region, x1, y2, 0, 0, 0, 1, xtex1, ytex2, c_white, ao);
        vertex_point_basic(emitter.region, xc, yc, 0, 0, 0, 1, xtexc, ytexc, c_white, ac);
        vertex_point_basic(emitter.region, x1, y2, 0, 0, 0, 1, xtex1, ytex2, c_white, ao);
        vertex_point_basic(emitter.region, x1, y1, 0, 0, 0, 1, xtex1, ytex1, c_white, ao);
        break;
    case PartEmitterShapes.ELLIPSE:
        vertex_point_basic(emitter.region, x1, y1, 0, 0, 0, 1, xtex1, ytex1, c_white, 0.125);
        vertex_point_basic(emitter.region, x2, y1, 0, 0, 0, 1, xtex2, ytex1, c_white, 0.125);
        vertex_point_basic(emitter.region, x2, y2, 0, 0, 0, 1, xtex2, ytex2, c_white, 0.125);
        vertex_point_basic(emitter.region, x2, y2, 0, 0, 0, 1, xtex2, ytex2, c_white, 0.125);
        vertex_point_basic(emitter.region, x1, y2, 0, 0, 0, 1, xtex1, ytex2, c_white, 0.125);
        vertex_point_basic(emitter.region, x1, y1, 0, 0, 0, 1, xtex1, ytex1, c_white, 0.125);
        break;
    case PartEmitterShapes.DIAMOND:
        var dxc = xc;
        var dyc = yc;
        var dx1 = xc;
        var dy1 = y1;
        var dx2 = x2;
        var dy2 = yc;
        var dx3 = xc;
        var dy3 = y2;
        var dx4 = x1;
        var dy4 = yc;
        var dxtexc = xtexc;
        var dytexc = ytexc;
        var dxtex1 = xtexc;
        var dytex1 = ytex1;
        var dxtex2 = xtex2;
        var dytex2 = ytexc;
        var dxtex3 = xtexc;
        var dytex3 = ytex2;
        var dxtex4 = xtex1;
        var dytex4 = ytexc;
        vertex_point_basic(emitter.region, dxc, dyc, 0, 0, 0, 1, dxtexc, dytexc, c_white, ac);
        vertex_point_basic(emitter.region, dx1, dy1, 0, 0, 0, 1, dxtex1, dytex1, c_white, ao);
        vertex_point_basic(emitter.region, dx2, dy2, 0, 0, 0, 1, dxtex2, dytex2, c_white, ao);
        vertex_point_basic(emitter.region, dxc, dyc, 0, 0, 0, 1, dxtexc, dytexc, c_white, ac);
        vertex_point_basic(emitter.region, dx2, dy2, 0, 0, 0, 1, dxtex2, dytex2, c_white, ao);
        vertex_point_basic(emitter.region, dx3, dy3, 0, 0, 0, 1, dxtex3, dytex3, c_white, ao);
        vertex_point_basic(emitter.region, dxc, dyc, 0, 0, 0, 1, dxtexc, dytexc, c_white, ac);
        vertex_point_basic(emitter.region, dx3, dy3, 0, 0, 0, 1, dxtex3, dytex3, c_white, ao);
        vertex_point_basic(emitter.region, dx4, dy4, 0, 0, 0, 1, dxtex4, dytex4, c_white, ao);
        vertex_point_basic(emitter.region, dxc, dyc, 0, 0, 0, 1, dxtexc, dytexc, c_white, ac);
        vertex_point_basic(emitter.region, dx4, dy4, 0, 0, 0, 1, dxtex4, dytex4, c_white, ao);
        vertex_point_basic(emitter.region, dx1, dy1, 0, 0, 0, 1, dxtex1, dytex1, c_white, ao);
        break;
    case PartEmitterShapes.LINE:
        var r = 16;
        var xtexr = r / sprite_get_width(b_tileset_checkers);
        var ytexr = r / sprite_get_height(b_tileset_checkers);
        vertex_point_basic(emitter.region, x1, y1, 0, 0, 0, 1, xtex1, ytex1, c_white, ao);
        vertex_point_basic(emitter.region, x1 + r, y1, 0, 0, 0, 1, xtex1 + xtexr, ytex1, c_white, ao);
        vertex_point_basic(emitter.region, x1, y1 + r, 0, 0, 0, 1, xtex1, ytex1 + ytexr, c_white, ao);
        
        vertex_point_basic(emitter.region, x1 + r, y1, 0, 0, 0, 1, xtex1 + xtexr, ytex1, c_white, ao);
        vertex_point_basic(emitter.region, xc + r, yc, 0, 0, 0, 1, xtexc + xtexr, ytexc, c_white, ac);
        vertex_point_basic(emitter.region, xc, yc, 0, 0, 0, 1, xtexc, ytexc, c_white, ac);
        
        vertex_point_basic(emitter.region, xc, yc, 0, 0, 0, 1, xtexc, ytexc, c_white, ac);
        vertex_point_basic(emitter.region, x1, y1 + r, 0, 0, 0, 1, xtex1, ytex1 + ytexr, c_white, ao);
        vertex_point_basic(emitter.region, x1 + r, y1, 0, 0, 0, 1, xtex1 + xtexr, ytex1, c_white, ao);
        
        vertex_point_basic(emitter.region, x1, y1 + r, 0, 0, 0, 1, xtex1, ytex1 + ytexr, c_white, ao);
        vertex_point_basic(emitter.region, xc, yc, 0, 0, 0, 1, xtexc, ytexc, c_white, ac);
        vertex_point_basic(emitter.region, xc - r, yc, 0, 0, 0, 1, xtexc - xtexr, ytexc, c_white, ac);
        
        vertex_point_basic(emitter.region, xc + r, yc, 0, 0, 0, 1, xtexc + xtexr, ytexc, c_white, ac);
        vertex_point_basic(emitter.region, x2, y2 - r, 0, 0, 0, 1, xtex2, ytex2 - ytexr, c_white, ao);
        vertex_point_basic(emitter.region, xc, yc, 0, 0, 0, 1, xtexc, ytexc, c_white, ac);
        
        vertex_point_basic(emitter.region, xc, yc, 0, 0, 0, 1, xtexc, ytexc, c_white, ac);
        vertex_point_basic(emitter.region, x2, y2 - r, 0, 0, 0, 1, xtex2, ytex2 - ytexr, c_white, ao);
        vertex_point_basic(emitter.region, x2 - r, y2, 0, 0, 0, 1, xtex2 - ytexr, ytex2, c_white, ao);
        
        vertex_point_basic(emitter.region, x2 - r, y2, 0, 0, 0, 1, xtex2 - ytexr, ytex2, c_white, ao);
        vertex_point_basic(emitter.region, xc - r, yc, 0, 0, 0, 1, xtexc - xtexr, ytexc, c_white, ac);
        vertex_point_basic(emitter.region, xc, yc, 0, 0, 0, 1, xtexc, ytexc, c_white, ac);
        
        vertex_point_basic(emitter.region, x2, y2, 0, 0, 0, 1, xtex2, ytex2, c_white, ao);
        vertex_point_basic(emitter.region, x2 - r, y2, 0, 0, 0, 1, xtex2 - xtexr, ytex2, c_white, ao);
        vertex_point_basic(emitter.region, x2, y2 - r, 0, 0, 0, 1, xtex2, ytex2 - ytexr, c_white, ao);
        break;
}
vertex_end(emitter.region);
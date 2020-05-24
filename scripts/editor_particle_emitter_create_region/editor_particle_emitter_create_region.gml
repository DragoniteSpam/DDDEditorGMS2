/// @param ParticleEmitter

var emitter = argument0;

var x1 = min(emitter.region_x1, emitter.region_x2);
var y1 = min(emitter.region_y1, emitter.region_y2);
var x2 = max(emitter.region_x1, emitter.region_x2);
var y2 = max(emitter.region_y1, emitter.region_y2);
var xtex1 = x1 / sprite_get_width(b_tileset_checkers);
var ytex1 = y1 / sprite_get_height(b_tileset_checkers);
var xtex2 = x2 / sprite_get_width(b_tileset_checkers);
var ytex2 = y2 / sprite_get_height(b_tileset_checkers);

vertex_begin(emitter.region, Stuff.graphics.vertex_format_basic);
switch (emitter.region_shape) {
    case PartEmitterShapes.RECTANGLE:
        vertex_point_basic(emitter.region, x1, y1, 0, 0, 0, 1, xtex1, ytex1, c_white, 0.125);
        vertex_point_basic(emitter.region, x2, y1, 0, 0, 0, 1, xtex2, ytex1, c_white, 0.125);
        vertex_point_basic(emitter.region, x2, y2, 0, 0, 0, 1, xtex2, ytex2, c_white, 0.125);
        vertex_point_basic(emitter.region, x2, y2, 0, 0, 0, 1, xtex2, ytex2, c_white, 0.125);
        vertex_point_basic(emitter.region, x1, y2, 0, 0, 0, 1, xtex1, ytex2, c_white, 0.125);
        vertex_point_basic(emitter.region, x1, y1, 0, 0, 0, 1, xtex1, ytex1, c_white, 0.125);
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
        vertex_point_basic(emitter.region, x1, y1, 0, 0, 0, 1, xtex1, ytex1, c_white, 0.125);
        vertex_point_basic(emitter.region, x2, y1, 0, 0, 0, 1, xtex2, ytex1, c_white, 0.125);
        vertex_point_basic(emitter.region, x2, y2, 0, 0, 0, 1, xtex2, ytex2, c_white, 0.125);
        vertex_point_basic(emitter.region, x2, y2, 0, 0, 0, 1, xtex2, ytex2, c_white, 0.125);
        vertex_point_basic(emitter.region, x1, y2, 0, 0, 0, 1, xtex1, ytex2, c_white, 0.125);
        vertex_point_basic(emitter.region, x1, y1, 0, 0, 0, 1, xtex1, ytex1, c_white, 0.125);
        break;
    case PartEmitterShapes.LINE:
        vertex_point_basic(emitter.region, x1, y1, 0, 0, 0, 1, xtex1, ytex1, c_white, 0.125);
        vertex_point_basic(emitter.region, x2, y1, 0, 0, 0, 1, xtex2, ytex1, c_white, 0.125);
        vertex_point_basic(emitter.region, x2, y2, 0, 0, 0, 1, xtex2, ytex2, c_white, 0.125);
        vertex_point_basic(emitter.region, x2, y2, 0, 0, 0, 1, xtex2, ytex2, c_white, 0.125);
        vertex_point_basic(emitter.region, x1, y2, 0, 0, 0, 1, xtex1, ytex2, c_white, 0.125);
        vertex_point_basic(emitter.region, x1, y1, 0, 0, 0, 1, xtex1, ytex1, c_white, 0.125);
        break;
}
vertex_end(emitter.region);
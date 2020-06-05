/// @param emitter

var emitter = argument0;
var odds = editor_particle_rate_odds(emitter.rate);
part_emitter_stream(Stuff.particle.system, emitter.emitter, emitter.type.type, emitter.streaming ? odds : 0);
/// @description spart_particles_create(partSystem, x, y, z, regionRadius, parttype, number)
/// @param partSystem
/// @param x
/// @param y
/// @param z
/// @param regionRadius
/// @param parttype
/// @param number
function spart_particles_create(argument0, argument1, argument2, argument3, argument4, argument5, argument6) {
    /*
        Creates a special type of emitter that only draws the given amount of particles.
        Once it's done, it's deleted in the smf_part_system_update script.

        Script created by TheSnidr
        www.thesnidr.com
    */
    var partSystem = argument0;
    var xx = argument1;
    var yy = argument2;
    var zz = argument3;
    var regionSize = argument4;
    var partType = argument5;
    var partNum = argument6;
    var partEmitter = spart_emitter_create(partSystem);
    partEmitter[| sPartEmt.PartType] = partType;
    partEmitter[| sPartEmt.EmitterType] = sPartEmitterType.Retired;
    partEmitter[| sPartEmt.Shape] = spart_shape_sphere;
    partEmitter[| sPartEmt.StartMat] = matrix_build(xx, yy, zz, 0, 0, 0, regionSize, regionSize, regionSize);
    partEmitter[| sPartEmt.EndMat] = partEmitter[| sPartEmt.StartMat];
    partEmitter[| sPartEmt.ParticlesPerStep] = 999999;
    partEmitter[| sPartEmt.LifeSpan] = partNum / partEmitter[| sPartEmt.ParticlesPerStep];
    spart__emitter_activate(partEmitter);


}

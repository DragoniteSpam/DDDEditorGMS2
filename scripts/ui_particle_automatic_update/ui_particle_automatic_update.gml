function ui_particle_automatic_update(checkbox) {
    Stuff.particle.system_auto_update = checkbox.value;
    checkbox.root.manual_update.interactive = !checkbox.value;
    part_system_automatic_update(Stuff.particle.system, checkbox.value);
    setting_set("Particle", "auto-update", checkbox.value);
}
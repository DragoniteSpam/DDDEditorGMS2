function ui_particle_emitter_set_region(button) {
    var selection = ui_list_selection(button.root.list);
    
    // 250 ms delay between when you kill the region and when you can click it again
    if (current_time - button.click_time < 250) return;
    
    if (selection + 1) {
        Stuff.particle.emitter_setting = Stuff.particle.emitters[| selection];
        Stuff.particle.emitter_first_corner = true;
        // this is the all-time worst hack for disabling the UI i have ever come up with
        var bad = dialog_create_notice(noone, "");
        bad.x = -10000;
        bad.y = -10000;
        bad.active_shade = false;
        part_system_automatic_update(Stuff.particle.system, false);
    }
}
/// @param EntityEffect
function safc_on_effect_ui(argument0) {

	var effect = argument0;

	safc_on_entity_ui(effect);

	Stuff.map.ui.element_effect_com_light.interactive = true;
	Stuff.map.ui.element_effect_com_particle.interactive = true;
	Stuff.map.ui.element_effect_com_audio.interactive = true;


}

/// @description  void uivc_stash(UIThing);
/// @param UIThing

// currently only UIInput objects have validation/value conversation
// scripts attached. that should probably change soon. they don't have
// to be complicated and can probably automatically return "true"
// though, since you already know that kind of data is good.

if (script_execute(argument0.validation, argument0.value)){
    argument0.root.data[? argument0.key]=script_execute(argument0.value_conversion, argument0.value);
}

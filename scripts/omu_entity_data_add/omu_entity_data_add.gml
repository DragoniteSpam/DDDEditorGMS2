function omu_entity_data_add(button) {
    var entity = button.root.entity;
    
    if (array_length(entity.generic_data) < 0x100) {
        array_push(entity.generic_data, new DataValue("GenericData" + string(array_length(entity.generic_data))));
    } else {
        emu_dialog_notice("Please don't try to create more than " + string(0xff) + " data types. If you need a lot of generic data grouped together you may want to create a type to represent instantiated enemies instead.");
    }
}
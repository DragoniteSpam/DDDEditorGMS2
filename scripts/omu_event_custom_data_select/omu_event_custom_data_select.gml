function omu_event_custom_data_select(button) {
    dialog_create_data_data_select(button, function() {
        var pselection = ui_list_selection(self.root.root.root.el_list);
        var property = self.root.root.root.event.types[pselection];
        var selection = self.GetSibling("LIST").GetSelectedItem();
        
        property.type_guid = selection.GUID;
        self.root.root.root.event.types[@ pselection] = property;
        self.root.root.root.el_property_type_guid.text = "Select (" + selection.name + ")";
        self.root.root.root.el_property_type_guid.color = c_black;
        self.root.root.root.changed = true;
    });
}
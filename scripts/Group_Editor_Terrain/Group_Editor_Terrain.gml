function EditorTerrainLightData(name) constructor {
    self.x = 0;
    self.y = 0;
    self.z = 0;
    self.name = name;
    self.color = c_white;
    self.type = LightTypes.NONE;
    self.radius = 256;
}
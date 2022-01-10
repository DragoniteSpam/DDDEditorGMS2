function dialog_create_credits() {
    var dw = 960;
    var dh = 400;
    var cx = 32;
    var cw = 896;
    var ch = 32;
    
    var dialog = new EmuDialog(960, 480, "Credits");
    
    dialog.AddContent([
        new EmuText(cx, EMU_AUTO, cw, ch, "[FDefault20][c_blue]DDD Game Editor"),
        
        #region me
        new EmuText(cx, EMU_AUTO, cw, ch, "Author: @DragoniteSpam"),
        new EmuButton(cx, EMU_AUTO, 216, 32, "Twitter", function() {
            url_open("https://twitter.com/dragonitespam");
        }),
        new EmuButton(cx + 224, EMU_INLINE, 216, 32, "YouTube", function() {
            url_open("https://www.youtube.com/c/dragonitespam");
        }),
        new EmuButton(cx + 224 * 2, EMU_INLINE, 216, 32, "Github", function() {
            url_open("https://github.com/DragoniteSpam");
        }),
        new EmuButton(cx + 224 * 3, EMU_INLINE, 216, 32, "Itch.io", function() {
            url_open("https://dragonite.itch.io/");
        }),
        #endregion
        
        #region extensions
        new EmuText(cx, EMU_AUTO, cw, ch, "[c_blue]Some GameMaker extensions were used"),
        new EmuButton(cx, EMU_AUTO, 216, 32, "Github", function() {
            url_open("https://github.com/JujuAdams/scribble");
        }),
        new EmuText(cx + 224, EMU_INLINE, cw, ch, "[rainbow][wave]Scribble,[] a Game Maker text renderer by Juju Adams (v" + string(__SCRIBBLE_VERSION) + ", slightly customized)"),
        new EmuButton(cx, EMU_AUTO, 216, 32, "Github", function() {
            url_open("https://github.com/GameMakerDiscord/Xpanda/");
        }),
        new EmuText(cx + 224, EMU_INLINE, cw, ch, "Xpanda, shader management by kraifpatrik"),
        #endregion
        
        #region default assets
        new EmuText(cx, EMU_AUTO, cw, ch, "[c_blue]Default assets"),
        new EmuText(cx, EMU_AUTO, cw, ch, "Water textures: Aswin Vos, and GodsAndIdols"),
        #endregion
    ]).AddDefaultCloseButton();
    
    return dialog;
}
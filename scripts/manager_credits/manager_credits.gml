function dialog_create_credits() {
    var dw = 960;
    var dh = 416;
    var cw = 896;
    var ch = 32;
    
    var bw = 224;
    
    var c1 = 32;
    var c2 = c1 + bw;
    var c3 = c2 + bw;
    var c4 = c3 + bw;
    
    var dialog = new EmuDialog(dw, dh, "Credits");
    
    dialog.AddContent([
        new EmuText(c1, EMU_AUTO, cw, 40, $"[FDefault20][c_aqua]DDD Game Tools ({GM_version})"),
        
        #region me
        new EmuText(c1, EMU_AUTO, dw - c1 * 2, ch, "Author: @DragoniteSpam, who is shamelessly plugging some of his own extensions:"),
        new EmuButton(c1, EMU_AUTO, bw, ch, "Bluesky", function() {
            url_open("https://bsky.app/profile/dragonitespam.bsky.social");
        }),
        new EmuButton(c2, EMU_INLINE, bw, ch, "YouTube", function() {
            url_open("https://www.youtube.com/c/dragonitespam");
        }),
        new EmuButton(c3, EMU_INLINE, bw, ch, "Github", function() {
            url_open("https://github.com/DragoniteSpam");
        }),
        new EmuButton(c4, EMU_INLINE, bw, ch, "Itch.io", function() {
            url_open("https://dragonite.itch.io/");
        }),
        new EmuButton(c1, EMU_AUTO, bw, ch, "Emu", function() {
            url_open("https://dragonite.itch.io/emu");
        }),
        new EmuButton(c2, EMU_INLINE, bw, ch, "drago.dll", function() {
            url_open("https://github.com/DragoniteSpam/drago.dll");
        }),
        new EmuButton(c3, EMU_INLINE, bw, ch, "Macaw", function() {
            url_open("https://dragonite.itch.io/macaw");
        }),
        new EmuButton(c4, EMU_INLINE, bw, ch, "[c_yellow]Wizarducks", function() {
            url_open("https://store.steampowered.com/app/2769920");
        }),
        #endregion
        
        #region extensions
        new EmuText(c1, EMU_AUTO, cw, ch, $"[#{string_copy(string(ptr(scribble_rgb_to_bgr(c_saffron))), 11, 6)}]Some additional GameMaker extensions were used:"),
        
        new EmuButton(c1, EMU_AUTO, bw, ch, "[rainbow]Scribble[/rainbow] by Juju Adams", function() {
            url_open("https://github.com/JujuAdams/scribble");
        }),
        new EmuButton(c2, EMU_INLINE, bw, ch, "[c_aqua]Carton[] by Juju Adams", function() {
            url_open("https://github.com/JujuAdams/carton");
        }),
        new EmuButton(c3, EMU_INLINE, bw, ch, "[c_aqua]SNAP[] by Juju Adams", function() {
            url_open("https://github.com/JujuAdams/SNAP");
        }),
        new EmuButton(c4, EMU_INLINE, bw, ch, "[c_aqua]Xpanda[] by kraifpatrik", function() {
            url_open("https://github.com/GameMakerDiscord/Xpanda/");
        }),
        new EmuButton(c1, EMU_AUTO, bw, ch, "[c_aqua]Assimp[] (yes it's called that)", function() {
            url_open("https://github.com/assimp/assimp");
        }),
        new EmuButton(c2, EMU_INLINE, bw, ch, "[c_aqua]GMD3D11[] by kraifpatrik", function() {
            url_open("https://github.com/blueburncz/GMD3D11");
        }),
        #endregion
    ]).AddDefaultCloseButton();
    
    return dialog;
}
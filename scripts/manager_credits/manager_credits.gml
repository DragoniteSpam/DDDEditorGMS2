function dialog_create_credits() {
    var dw = 960;
    var dh = 400;
    var cx = 32;
    var cw = 896;
    var ch = 32;
    
    var bw = 216;
    
    var dialog = new EmuDialog(960, 560, "Credits");
    
    dialog.AddContent([
        new EmuText(cx, EMU_AUTO, cw, 40, $"[FDefault20][c_aqua]DDD Game Tools ({GM_version})"),
        
        #region me
        new EmuText(cx, EMU_AUTO, dw - cx * 2, ch, "Author: @DragoniteSpam, who is shamelessly plugging some of his own extensions:"),
        new EmuButton(cx, EMU_AUTO, bw, ch, "Bluesky", function() {
            url_open("https://bsky.app/profile/dragonitespam.bsky.social");
        }),
        new EmuButton(cx + 224, EMU_INLINE, bw, ch, "YouTube", function() {
            url_open("https://www.youtube.com/c/dragonitespam");
        }),
        new EmuButton(cx + 224 * 2, EMU_INLINE, bw, ch, "Github", function() {
            url_open("https://github.com/DragoniteSpam");
        }),
        new EmuButton(cx + 224 * 3, EMU_INLINE, bw, ch, "Itch.io", function() {
            url_open("https://dragonite.itch.io/");
        }),
        new EmuButton(cx, EMU_AUTO, bw, ch, "Emu", function() {
            url_open("https://dragonite.itch.io/emu");
        }),
        new EmuButton(cx + 224, EMU_INLINE, bw, ch, "drago.dll", function() {
            url_open("https://github.com/DragoniteSpam/drago.dll");
        }),
        new EmuButton(cx + 224 * 2, EMU_INLINE, bw, ch, "Macaw", function() {
            url_open("https://dragonite.itch.io/macaw");
        }),
        #endregion
        
        #region extensions
        new EmuText(cx, EMU_AUTO, cw, ch, $"[#{string_copy(string(ptr(scribble_rgb_to_bgr(c_saffron))), 11, 6)}]Some additional GameMaker extensions were used:"),
        // scribble
        new EmuButton(cx, EMU_AUTO, bw, ch, "Github", function() {
            url_open("https://github.com/JujuAdams/scribble");
        }),
        new EmuText(cx + 224, EMU_INLINE, cw, ch, "[rainbow]Scribble,[/rainbow] a Game Maker text renderer by Juju Adams (v" + string(__SCRIBBLE_VERSION) + ", slightly customized)"),
        // carton
        new EmuButton(cx, EMU_AUTO, bw, ch, "Github", function() {
            url_open("https://github.com/JujuAdams/carton");
        }),
        new EmuText(cx + 224, EMU_INLINE, cw, ch, "[c_aqua]Carton[] by Juju Adams (v" + string(__CARTON_VERSION) + ")"),
        // snap
        new EmuButton(cx, EMU_AUTO, bw, ch, "Github", function() {
            url_open("https://github.com/JujuAdams/SNAP");
        }),
        new EmuText(cx + 224, EMU_INLINE, cw, ch, "[c_aqua]SNAP[] by Juju Adams"),
        // panda
        new EmuButton(cx, EMU_AUTO, bw, ch, "Github", function() {
            url_open("https://github.com/GameMakerDiscord/Xpanda/");
        }),
        new EmuText(cx + 224, EMU_INLINE, cw, ch, "[c_aqua]Xpanda,[] shader management by kraifpatrik"),
        // assimp
        new EmuButton(cx, EMU_AUTO, bw, ch, "Github", function() {
            url_open("https://github.com/assimp/assimp");
        }),
        new EmuText(cx + 224, EMU_INLINE, cw, ch, "[c_aqua]Assimp,[] the Open Asset Importer Library"),
        #endregion
    ]).AddDefaultCloseButton();
    
    return dialog;
}
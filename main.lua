-- name: NonStop Music
-- description: Custom soundtrack by Jackafur\nBased on Kettle's Sound by KettleClog\n\nReplaces the soundtrack with new, original songs for a fresh experience, inspired by classic sound mods.

-- Based on Kettle's Sound by KettleClog (the per-level songs, the two-song pick, the
-- silenced jingles and most of the tracks). Full credits and song sources: README.md
-- and SOURCES.md.
--
-- Rewritten for the NonStop RTD HnS server. Same songs, names and "Now Playing" banner as
-- the 2025 versions (kept in originals/NonStop-Music), plus Peach's Castle on the castle
-- grounds. What changed:
-- - three options in the mod menu, saved per player (defaults in brackets):
--     Google Sheet Song Layout [on]: on = the NonStopHnS Playlist sheet (every level its
--       own song, BBH and SSL two); off = shared pairs, how the mod played in 2025
--     Shuffle Between 2 Songs [on]: off always plays a level's first song
--     New Song After Exit Course [off]: off keeps the song playing through a trip to the
--       castle (Exit Course, Hide and Seek pulling you back into the round's level)
--   Sheet off, shuffle on, new song on = how it played in 2025, plus the castle grounds song.
-- - each song is loaded once and kept, never freed (with [wip] in the name the game
--   keeps a mod's files in memory only until their first load, so a freed song was
--   gone for good: two songs, then the level's own music)
-- - the song is picked once per level: every warp (deaths, room changes) used to
--   re-roll it and restart it from the top, and a level change loaded it twice
-- - the level's own theme can't come back on top (after caps, RTD events, rooms)
-- - pauses while an RTD event song plays (RTD sets _G.rtdEventMusic)
-- - the banner sets its own HUD resolution, and nothing runs on the headless server
-- - smaller download: the unused castle song copies and CCM2 are left out, and the
--   few big songs are re-encoded to match the rest (about 60 kbps Ogg)

-- cap and slide music would cut into the songs, so they're silent
smlua_audio_utils_replace_sequence(SEQ_EVENT_METAL_CAP, 0, 0.00000001, "_silent")
smlua_audio_utils_replace_sequence(SEQ_EVENT_POWERUP, 0, 0.00000001, "_silent")
smlua_audio_utils_replace_sequence(SEQ_LEVEL_SLIDE, 0, 0.00000001, "_silent")

local SONG_NAMES = {
    ["BOB1.ogg"] = "Delta Rune - Field of Hopes and Dreams",
    ["BOB2.ogg"] = "Paper Mario: Sticker Star - Warm Fuzzy Plains",
    ["WF1.ogg"] = "Touhou Mountain of Faith - Romantic Fall",
    ["WF2.ogg"] = "Super Mario 3D Land - Overworld Theme",
    ["SSL1.ogg"] = "Mega Man 6 - Tomahawk Man",
    ["SSL2.ogg"] = "Super Paper Mario - Sammers Kingdom",
    ["SL.ogg"] = "Castlevania 64 - Renon's Theme",
    ["CCM1.ogg"] = "Mario Kart Wii - DK's Snowboard Cross",
    ["BBH1.ogg"] = "Touhou: EoSD - Patchouli Knowledge",
    ["BBH2.ogg"] = "Mega Man 7 - Shade Man",
    ["HMC1.ogg"] = "LoZ: AoL - Hyrule Temple",
    ["BITDW1.ogg"] = "Mega Man 2 - Wily Stage 1",
    ["BITDW2.ogg"] = "Mega Man 3 - Wily Stage 1",
    ["BITFS1.ogg"] = "Castlevania - Bloody Tears",
    ["B1.ogg"] = "Super Paper Mario - Fracktail",
    ["B2.ogg"] = "Touhou: EoSD - Tomboyish Girl In Love",
    ["B3.ogg"] = "Undertale - Megalovania",
    ["VCUTM1.ogg"] = "Melee - Break the Targets",
    ["VCUTM2.ogg"] = "Mega Man X - Armored Armadillo",
    ["B5.ogg"] = "Super Metroid - Lower Norfair",
    ["RR.ogg"] = "Cyberdeous - DBZ Opening - CHA-LA HEAD-CHA-LA",
    ["PSS.ogg"] = "Puyo Puyo - Theme",
    ["COTMC1.ogg"] = "FF4 Battle remixed for FF14",
    ["CastleWalls.ogg"] = "Mario & Luigi: Superstar Saga - Peach's Castle",
}

-- Songs per level. Levels not listed keep their own music. With Shuffle on, a level with
-- two songs picks one each time you enter it; off, it plays the first one.

-- Where the NonStopHnS Playlist sheet (SOURCES.md) puts them: every level its own song.
-- The sheet lists SSL2 under "ICW" (not a real level) and notes it plays in SSL.
local SHEET_SONGS = {
    [LEVEL_BOB] = { "BOB1.ogg" },
    [LEVEL_THI] = { "BOB2.ogg" },
    [LEVEL_WF] = { "WF2.ogg" },
    [LEVEL_TTM] = { "WF1.ogg" },
    [LEVEL_CCM] = { "CCM1.ogg" },
    [LEVEL_BBH] = { "BBH1.ogg", "BBH2.ogg" },
    [LEVEL_HMC] = { "HMC1.ogg" },
    [LEVEL_LLL] = { "B5.ogg" },
    [LEVEL_SSL] = { "SSL1.ogg", "SSL2.ogg" },
    [LEVEL_SL] = { "SL.ogg" },
    [LEVEL_TTC] = { "VCUTM2.ogg" },
    [LEVEL_RR] = { "RR.ogg" },
    [LEVEL_PSS] = { "PSS.ogg" },
    [LEVEL_COTMC] = { "COTMC1.ogg" },
    [LEVEL_VCUTM] = { "VCUTM1.ogg" },
    [LEVEL_BITDW] = { "BITDW2.ogg" },
    [LEVEL_BITFS] = { "BITDW1.ogg" },
    [LEVEL_BITS] = { "BITFS1.ogg" },
    [LEVEL_BOWSER_1] = { "B1.ogg" },
    [LEVEL_BOWSER_2] = { "B2.ogg" },
    [LEVEL_BOWSER_3] = { "B3.ogg" },
    [LEVEL_CASTLE] = { "CastleWalls.ogg" },
    [LEVEL_CASTLE_GROUNDS] = { "CastleWalls.ogg" },
}

-- The 2025 NonStop Music layout: sister levels share a pair (BOB and THI both pick from
-- BOB1/BOB2, WF and TTM from WF1/WF2, VCUTM and TTC from VCUTM1/VCUTM2).
local PAIRED_SONGS = {
    [LEVEL_BOB] = { "BOB1.ogg", "BOB2.ogg" },
    [LEVEL_THI] = { "BOB1.ogg", "BOB2.ogg" },
    [LEVEL_WF] = { "WF1.ogg", "WF2.ogg" },
    [LEVEL_TTM] = { "WF1.ogg", "WF2.ogg" },
    [LEVEL_CCM] = { "CCM1.ogg" },
    [LEVEL_BBH] = { "BBH1.ogg", "BBH2.ogg" },
    [LEVEL_HMC] = { "HMC1.ogg" },
    [LEVEL_LLL] = { "B5.ogg" },
    [LEVEL_SSL] = { "SSL1.ogg", "SSL2.ogg" },
    [LEVEL_SL] = { "SL.ogg" },
    [LEVEL_TTC] = { "VCUTM1.ogg", "VCUTM2.ogg" },
    [LEVEL_RR] = { "RR.ogg" },
    [LEVEL_PSS] = { "PSS.ogg" },
    [LEVEL_COTMC] = { "COTMC1.ogg" },
    [LEVEL_VCUTM] = { "VCUTM1.ogg", "VCUTM2.ogg" },
    [LEVEL_BITDW] = { "BITDW1.ogg", "BITDW2.ogg" },
    [LEVEL_BITFS] = { "BITDW1.ogg", "BITFS1.ogg" },
    [LEVEL_BITS] = { "BITFS1.ogg" },
    [LEVEL_BOWSER_1] = { "B1.ogg" },
    [LEVEL_BOWSER_2] = { "B2.ogg" },
    [LEVEL_BOWSER_3] = { "B3.ogg" },
    [LEVEL_CASTLE] = { "CastleWalls.ogg" },
    [LEVEL_CASTLE_GROUNDS] = { "CastleWalls.ogg" },
}

-- the castle levels you pass through when you leave a course
local HUB_LEVELS = {
    [LEVEL_CASTLE] = true,
    [LEVEL_CASTLE_GROUNDS] = true,
    [LEVEL_CASTLE_COURTYARD] = true,
}

-- the levels' own themes, kept off while one of our songs plays
local LEVEL_SEQS = {}
for _, seq in ipairs({ SEQ_LEVEL_GRASS, SEQ_LEVEL_INSIDE_CASTLE, SEQ_LEVEL_WATER, SEQ_LEVEL_HOT,
    SEQ_LEVEL_BOSS_KOOPA, SEQ_LEVEL_SNOW, SEQ_LEVEL_SLIDE, SEQ_LEVEL_SPOOKY, SEQ_LEVEL_UNDERGROUND,
    SEQ_LEVEL_KOOPA_ROAD, SEQ_LEVEL_BOSS_KOOPA_FINAL }) do
    LEVEL_SEQS[seq] = true
end

local BANNER_FRAMES = 5 * 30
local BANNER_FADE = 2 * 30

local streams = {}         -- file -> stream, loaded on first use and kept
local track = nil          -- the stream that's playing
local songName = ""
local currentLevel = -1
local songLevel = -1       -- the level the playing song was picked for
local pausedForRtd = false
local bannerTimer = 0

-- the mod menu options (sheetLayout replaced "2025 Song Layout", saved as pairedLayout,
-- which meant the opposite: carry that choice over)
local changeOnExit = mod_storage_load_bool("changeOnExit", false)
local randomPick = mod_storage_load_bool("randomPick", true)
local sheetLayout = mod_storage_load_bool("sheetLayout", not mod_storage_load_bool("pairedLayout", false))

local function is_headless()
    return gServerSettings.headlessServer ~= 0 and network_is_server()
end

local function stop_song()
    if track ~= nil then audio_stream_stop(track) end
    track = nil
    songName = ""
    bannerTimer = 0
end

-- Never destroyed: for a [wip] mod the game deletes its in-memory copy of the song on
-- the first audio_stream_load, so a destroyed stream can't be loaded again.
local function get_stream(file)
    local stream = streams[file]
    if stream == nil then
        stream = audio_stream_load(file)
        if stream == nil then return nil end
        audio_stream_set_looping(stream, true)
        streams[file] = stream
    end
    return stream
end

local function play_song(file)
    stop_song()
    track = get_stream(file)
    if track == nil then return end
    audio_stream_play(track, true, 1)
    pausedForRtd = false
    songName = SONG_NAMES[file] or file
    bannerTimer = BANNER_FRAMES
end

local function pick_song(level)
    local songs = (sheetLayout and SHEET_SONGS or PAIRED_SONGS)[level]
    if songs == nil then return nil end
    if randomPick then return songs[math.random(#songs)] end
    return songs[1]
end

local function start_level_song(level)
    local file = pick_song(level)
    if file == nil then
        stop_song()
    else
        play_song(file)
        songLevel = level
    end
end

-- A new level gets a new song. Deaths, rooms and new rounds in the same level keep it.
-- With New Song After Exit Course off, passing through the castle keeps the song too, and
-- coming back to the level it was picked for doesn't restart it. A new Hide and Seek
-- round (HnS shares its state as _G.hnsGameState, 1 = everyone is being warped to the
-- new stage) always picks.
local function on_level_change()
    if is_headless() then return end
    local level = gNetworkPlayers[0].currLevelNum
    if level == currentLevel then return end
    currentLevel = level
    local newRound = _G.hnsGameState == 1
    if not changeOnExit and track ~= nil and not newRound and (HUB_LEVELS[level] or level == songLevel) then
        return
    end
    start_level_song(level)
end

local function on_change_on_exit(_, value)
    changeOnExit = value
    mod_storage_save_bool("changeOnExit", value)
end

-- layout and pick changes apply right away, so you can hear the difference
local function on_random_pick(_, value)
    randomPick = value
    mod_storage_save_bool("randomPick", value)
    if not is_headless() and currentLevel >= 0 then start_level_song(currentLevel) end
end

local function on_sheet_layout(_, value)
    sheetLayout = value
    mod_storage_save_bool("sheetLayout", value)
    if not is_headless() and currentLevel >= 0 then start_level_song(currentLevel) end
end

local function update()
    if bannerTimer > 0 then bannerTimer = bannerTimer - 1 end
    if track == nil then return end

    -- RTD's event songs (moon jump, dance, mega mushroom...) play instead for a while
    local rtdSong = _G.rtdEventMusic == true
    if rtdSong ~= pausedForRtd then
        pausedForRtd = rtdSong
        if rtdSong then audio_stream_pause(track) else audio_stream_play(track, false, 1) end
    end
    if pausedForRtd then return end

    -- the level's theme restarts after caps, RTD events and room changes: keep it off
    local bg = get_current_background_music()
    if bg ~= 0xFFFF and LEVEL_SEQS[bg & 0xFF] then stop_background_music(bg) end

    audio_stream_set_volume(track, is_game_paused() and 0.2 or 1)
end

local function on_hud_render()
    if bannerTimer <= 0 or songName == "" then return end
    local alpha = math.min(1, bannerTimer / BANNER_FADE)

    djui_hud_set_resolution(RESOLUTION_DJUI)
    djui_hud_set_font(FONT_NORMAL)
    local text = "Now Playing: " .. songName
    local w = djui_hud_measure_text(text)
    local x = (djui_hud_get_screen_width() - w) / 2
    -- box 114-160: 10 under Hide and Seek's top boxes (its "Releasing Seekers" box is 40-104)
    local y, pad = 122, 8

    djui_hud_set_color(0, 0, 0, 192 * alpha)
    djui_hud_render_rect(x - pad, y - pad, w + pad * 2, 30 + pad * 2)
    djui_hud_set_color(0, 0, 0, 255 * alpha)
    djui_hud_print_text(text, x + 2, y + 2, 1)
    djui_hud_set_color(255, 255, 255, 255 * alpha)
    djui_hud_print_text(text, x, y, 1)
end

hook_event(HOOK_ON_LEVEL_INIT, on_level_change)
hook_event(HOOK_ON_WARP, on_level_change)
hook_event(HOOK_UPDATE, update)
hook_event(HOOK_ON_HUD_RENDER, on_hud_render)
hook_mod_menu_checkbox("Google Sheet Song Layout", sheetLayout, on_sheet_layout)
hook_mod_menu_checkbox("Shuffle Between 2 Songs", randomPick, on_random_pick)
hook_mod_menu_checkbox("New Song After Exit Course", changeOnExit, on_change_on_exit)

-- name: NonStop Music
-- description: Custom soundtrack by Jackafur\nBased on Kettle's Sound by KettleClog\n\nReplaces the soundtrack with new, original songs for a fresh experience, inspired by classic sound mods.

-- Silence default tracks
smlua_audio_utils_replace_sequence(SEQ_EVENT_METAL_CAP, 0, 0.00000001, "_silent")
smlua_audio_utils_replace_sequence(SEQ_EVENT_POWERUP, 0, 0.00000001, "_silent")
smlua_audio_utils_replace_sequence(SEQ_LEVEL_SLIDE, 0, 0.00000001, "_silent")

-- Map audio files to display names
local song_names = {
    ["BOB1.ogg"] = "Delta Rune - Field of Hopes and Dreams ",
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
    ["CastleWalls.mp3"] = "Mario & Luigi: Superstar Saga - Peach's Castle"
}

-- Global variables
local currentTrack = nil
gCurrentSongName = "" -- Global to share with hud.lua

function randomize_song()
    return math.random(1, 2) -- Returns 1 or 2 for song selection
end

function randomize_song_on_level_load()
    -- Randomize song when level is loaded
    local song = randomize_song()
    gCurrentSongName = "" -- Reset song name
    on_warp(song) -- Call on_warp with the randomized song
end

hook_event(HOOK_ON_LEVEL_INIT, randomize_song_on_level_load)

function on_warp(song)
    if not song then
        song = randomize_song() -- Randomize if not provided
    end

    local level = gNetworkPlayers[0].currLevelNum
    local track = nil
    local song_file = nil

    -- Stop current track if playing
    if currentTrack then
        audio_stream_stop(currentTrack)
        currentTrack = nil
    end

    -- Select track based on level and song number
    if level == LEVEL_BOB then
        song_file = song == 1 and "BOB1.ogg" or "BOB2.ogg"
    elseif level == LEVEL_WF then
        song_file = song == 1 and "WF1.ogg" or "WF2.ogg"
    elseif level == LEVEL_ICW then
        song_file = song == 1 and "SSL1.ogg" or "SSL2.ogg"
    elseif level == LEVEL_THI then
        song_file = song == 1 and "BOB1.ogg" or "BOB2.ogg"
    elseif level == LEVEL_TTM then
        song_file = song == 1 and "WF1.ogg" or "WF2.ogg"
    elseif level == LEVEL_SL then
        song_file = "SL.ogg"
    elseif level == LEVEL_CCM then
        song_file = "CCM1.ogg"
    elseif level == LEVEL_BBH then
        song_file = song == 1 and "BBH1.ogg" or "BBH2.ogg"
    elseif level == LEVEL_HMC then
        song_file = "HMC1.ogg"
    elseif level == LEVEL_SSL then
        song_file = song == 1 and "SSL1.ogg" or "SSL2.ogg"
    elseif level == LEVEL_BITDW then
        song_file = song == 1 and "BITDW1.ogg" or "BITDW2.ogg"
    elseif level == LEVEL_BITFS then
        song_file = song == 1 and "BITDW1.ogg" or "BITFS1.ogg"
    elseif level == LEVEL_BITS then
        song_file = "BITFS1.ogg"
    elseif level == LEVEL_BOWSER_1 then
        song_file = "B1.ogg"
    elseif level == LEVEL_BOWSER_2 then
        song_file = "B2.ogg"
    elseif level == LEVEL_BOWSER_3 then
        song_file = "B3.ogg"
    elseif level == LEVEL_VCUTM then
        song_file = song == 1 and "VCUTM1.ogg" or "VCUTM2.ogg"
    elseif level == LEVEL_LLL then
        song_file = "B5.ogg"
    elseif level == LEVEL_TTC then
        song_file = song == 1 and "VCUTM1.ogg" or "VCUTM2.ogg"
    elseif level == LEVEL_RR then
        song_file = "RR.ogg"
    elseif level == LEVEL_PSS then
        song_file = "PSS.ogg"
    elseif level == LEVEL_COTMC then
        song_file = "COTMC1.ogg"
    elseif level == LEVEL_CASTLE then
        song_file = "CastleWalls.mp3"
    end

    if song_file then
        track = audio_stream_load(song_file)
        gCurrentSongName = song_names[song_file] or song_file -- Set display name or fallback to filename
    end

    if track then
        stop_background_music(get_current_background_music())
        audio_stream_set_looping(track, true)
        audio_stream_play(track, true, 1)
        currentTrack = track
    end
end

hook_event(HOOK_ON_WARP, function() on_warp(nil) end)
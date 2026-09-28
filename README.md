# NonStop Music

A custom soundtrack mod for [SM64CoopDX](https://github.com/coop-deluxe/sm64coopdx) by Jackafur,
based on **Kettle's Sound by KettleClog**. It replaces the level music with songs from other
games, and a "Now Playing" box fades in at the top of the screen with the song name. Which song
plays where, and when it changes, is up to each player (see Options).

Built for the NonStop servers in 2025 and run on all of them.

## Install

Copy this folder into your SM64CoopDX `mods` folder as `NonStop-Music`, then enable it from the
host's mod list (or `--enable-mod NonStop-Music` on a headless server).

## Tracks

These are the names the HUD shows. Full sources (original game, composer, remix artist and
arrangement for every track) are in [SOURCES.md](SOURCES.md).

| File | Song |
| --- | --- |
| BOB1 | Deltarune - Field of Hopes and Dreams |
| BOB2 | Paper Mario: Sticker Star - Warm Fuzzy Plains |
| WF1 | Touhou Mountain of Faith - Romantic Fall |
| WF2 | Super Mario 3D Land - Overworld Theme |
| SSL1 | Mega Man 6 - Tomahawk Man |
| SSL2 | Super Paper Mario - Sammer's Kingdom |
| SL | Castlevania 64 - Renon's Theme |
| CCM1 | Mario Kart Wii - DK's Snowboard Cross |
| BBH1 | Touhou: EoSD - Patchouli Knowledge |
| BBH2 | Mega Man 7 - Shade Man |
| HMC1 | LoZ: AoL - Hyrule Temple |
| BITDW1 | Mega Man 2 - Wily Stage 1 |
| BITDW2 | Mega Man 3 - Wily Stage 1 |
| BITFS1 | Castlevania - Bloody Tears |
| B1 | Super Paper Mario - Fracktail |
| B2 | Touhou: EoSD - Tomboyish Girl In Love |
| B3 | Undertale - Megalovania |
| B5 | Super Metroid - Lower Norfair |
| VCUTM1 | Melee - Break the Targets |
| VCUTM2 | Mega Man X - Armored Armadillo |
| RR | Cyberdeous - DBZ Opening - CHA-LA HEAD-CHA-LA |
| PSS | Puyo Puyo - Theme |
| COTMC1 | FF4 Battle remixed for FF14 |
| CastleWalls | Mario & Luigi: Superstar Saga - Peach's Castle |

This copy is the 2026 rewrite for the RTD HnS server (see the top of `main.lua`): the unused
`CCM2.ogg` and the `Castle Walls.mp3` / `CastleWalls.ogg` duplicates are left out, the castle
song is an Ogg now, and B5, COTMC1, SL and WF2 are re-encoded to match the other songs (about
60 kbps), so the download is 17 MB instead of 25. `_silent.m64` mutes the metal cap and power-up jingles and the slide
music so they do not cut over the custom track.

All songs belong to their original composers and publishers. This repo only arranges them into
a mod.

## Credits

The original mod is **Kettle's Sound by KettleClog**: the per-level track swapping, the
two-song random pick, the `_silent` jingle muting and most of the tracks. Jackafur's changes on
top of it:

- the "Now Playing" HUD popup (was `hud.lua`, now in `main.lua`) and the song name list
- new tracks: SL (Renon's Theme), COTMC1 (FF4 Battle remix), CastleWalls (Peach's Castle)
- a different B5 track (Lower Norfair)
- general cleanup, renamed to NonStop Music for the NonStop servers

Big thanks to KettleClog for being fine with this and for helping identify the remixes.

## History

The commits are the three versions found on the old ThinkCentre server box, with their original
file dates:

1. **May 31 2025**, first deployed version (also the copy in `sm64coopdx-mods`).
2. **Jun 9 2025**, WF1 named and the Sammer's Kingdom apostrophe fixed. This is the copy the
   RTD and shyguy servers ran.
3. **Jun 5 2025**, the main drench server's copy: the same fixes plus the Cyberdeous credit and
   a warp hook that re-picks the song on every warp. The most complete version, so it is the
   latest commit even though its file date is earlier.
4. **Sep 2026**, the rewrite for the RTD HnS server on SM64CoopDX v1.5.1: the song is picked
   once per level instead of on every warp, each song is loaded once and kept, it pauses while
   a Roll The Dice event song plays, the level's own theme can't come back on top, Peach's
   Castle also plays on the castle grounds, and the download is 17 MB.

## Options

Pause menu, Mod Menu, NonStop Music. Each player sets their own, and they're saved.

| Option | Default | What it does |
| --- | --- | --- |
| Google Sheet Song Layout | on | On: the NonStopHnS Playlist sheet's layout, every level its own song (BBH and SSL have two). Off: shared pairs, how the mod actually played in 2025 (BOB and THI both pick from BOB1/BOB2, WF and TTM from WF1/WF2, VCUTM and TTC from VCUTM1/VCUTM2, BITFS from BITDW1/BITFS1) |
| Shuffle Between 2 Songs | on | A level with two songs picks one at random each time. Off: always the first one |
| New Song After Exit Course | off | Off: leaving a course through the castle (Exit Course, or Hide and Seek pulling you back into the round's level) keeps the song playing, and coming back doesn't restart it. A new level or a new Hide and Seek round still picks. On: every level change picks again |

Sheet off, shuffle on and new song on is how the mod played in 2025. Changing the layout or
the shuffle switches the song right away.

| Level | Sheet layout (default) | Shared pairs (sheet off) |
| --- | --- | --- |
| BOB | BOB1 | BOB1 or BOB2 |
| THI | BOB2 | BOB1 or BOB2 |
| WF | WF2 | WF1 or WF2 |
| TTM | WF1 | WF1 or WF2 |
| SSL | SSL1 or SSL2 | SSL1 or SSL2 |
| BBH | BBH1 or BBH2 | BBH1 or BBH2 |
| BITDW | BITDW2 | BITDW1 or BITDW2 |
| BITFS | BITDW1 | BITDW1 or BITFS1 |
| BITS | BITFS1 | BITFS1 |
| VCUTM | VCUTM1 | VCUTM1 or VCUTM2 |
| TTC | VCUTM2 | VCUTM1 or VCUTM2 |
| Castle, castle grounds | CastleWalls | CastleWalls |
| CCM, SL, HMC, LLL, RR, PSS, COTMC, Bowser 1/2/3 | one song each, the same in both | |

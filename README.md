# NonStop Music

A custom soundtrack mod for [SM64CoopDX](https://github.com/coop-deluxe/sm64coopdx) by Jackafur,
based on **Kettle's Sound by KettleClog**. It replaces the level music with songs from other games. Many levels randomly pick one of two
tracks each time you enter, and a "Now Playing" box fades in at the top of the screen with the
song name.

Built for the NonStop servers in 2025 and run on all of them.

## Install

Copy this folder into your SM64CoopDX `mods` folder as `NonStop-Music`, then enable it from the
host's mod list (or `--enable-mod NonStop-Music` on a headless server).

## Tracks

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

`CCM2.ogg` and the `Castle Walls.mp3` / `CastleWalls.ogg` duplicates ship in `sound/` but are
not referenced by the code. `_silent.m64` mutes the metal cap and power-up jingles and the slide
music so they do not cut over the custom track.

All songs belong to their original composers and publishers. This repo only arranges them into
a mod.

## Credits

The original mod is **Kettle's Sound by KettleClog**: the per-level track swapping, the
two-song random pick, the `_silent` jingle muting and most of the tracks. Jackafur's changes on
top of it:

- the "Now Playing" HUD popup (`hud.lua`) and the song name list
- new tracks: SL (Renon's Theme), COTMC1 (FF4 Battle remix), CastleWalls (Peach's Castle)
- a different B5 track (Lower Norfair)
- general cleanup, renamed to NonStop Music for the NonStop servers

## History

The commits are the three versions found on the old ThinkCentre server box, with their original
file dates:

1. **May 31 2025**, first deployed version (also the copy in `sm64coopdx-mods`).
2. **Jun 9 2025**, WF1 named and the Sammer's Kingdom apostrophe fixed. This is the copy the
   RTD and shyguy servers ran.
3. **Jun 5 2025**, the main drench server's copy: the same fixes plus the Cyberdeous credit and
   a warp hook that re-picks the song on every warp. The most complete version, so it is the
   latest commit even though its file date is earlier.

-- HUD display for NonStop Music mod
-- Displays the current song name with a transparent black box and shadow when a level loads

local display_timer = 0
local display_duration = 5 * 30 -- 5 seconds at 30 FPS
local fade_duration = 2 * 30   -- Fade out over last 2 seconds

function hud_display_song()
    if gCurrentSongName == "" then return end

    -- Increment timer
    if display_timer < display_duration then
        display_timer = display_timer + 1
    end

    -- Calculate alpha for fade-out
    local alpha = 1.0
    if display_timer > (display_duration - fade_duration) then
        local fade_progress = (display_timer - (display_duration - fade_duration)) / fade_duration
        alpha = 1.0 - fade_progress
    end

    -- Get screen dimensions
    local screen_width = djui_hud_get_screen_width()
    local screen_height = djui_hud_get_screen_height()

    -- Set text properties
    local text = "Now Playing: " .. gCurrentSongName
    local scale = 1.0  -- Larger text size
    local offset = 2 * scale  -- Shadow offset proportional to scale
    local text_width = djui_hud_measure_text(text) * scale
    local text_height = 30 * scale  -- Approximate height for FONT_NORMAL
    local x = (screen_width - text_width) / 2
    local y = 100  -- Position to avoid overlapping with other HUD elements (adjust if needed)

    -- Calculate rectangle dimensions with padding
    local padding = 8  -- Space around the text
    local rect_width = text_width + padding * 2
    local rect_height = text_height + padding * 2
    local rect_x = x - padding
    local rect_y = y - padding

    -- Render semi-transparent black rectangle (darker)
    djui_hud_set_color(0, 0, 0, math.floor(alpha * 192))  -- Alpha 192 for a darker box
    djui_hud_render_rect(rect_x, rect_y, rect_width, rect_height)

    -- Render shadow text
    djui_hud_set_font(FONT_NORMAL)
    djui_hud_set_color(0, 0, 0, math.floor(alpha * 255))
    djui_hud_print_text(text, x + offset, y + offset, scale)

    -- Render main text
    djui_hud_set_color(255, 255, 255, math.floor(alpha * 255))
    djui_hud_print_text(text, x, y, scale)
end

function on_hud_render()
    hud_display_song()
end

function on_warp_hud()
    -- Commented out to prevent showing song name on warp, but function remains
    -- display_timer = 0
end

function on_level_init_hud()
    -- Reset timer on level load to show song name
    display_timer = 0
end

hook_event(HOOK_ON_HUD_RENDER, on_hud_render)
hook_event(HOOK_ON_WARP, on_warp_hud)
hook_event(HOOK_ON_LEVEL_INIT, on_level_init_hud)
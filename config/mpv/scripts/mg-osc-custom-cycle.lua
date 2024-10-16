-- https://github.com/mpv-player/mpv/issues/4896#issuecomment-330458533
mp.add_key_binding(nil, "osc-cycle-reverse", function()
    -- by default OSC cycles between auto/always/never
    -- I want it to cycle between auto/never/always
    local mode = mp.get_property_native("user-data/osc/visibility")
    if mode == "auto" then
        mode = "never"
    elseif mode == "never" then
        mode = "always"
    else
        mode = "auto"
    end
    mp.command("script-message osc-visibility " .. mode)
end)

---@module 'hl'

-- --- Sargasso Sea Theme ---

hl.config({
    general = {
        gaps_in = 6,
        gaps_out = 12,
        border_size = 2,
        col = {
            active_border = { colors = { "rgba(2abcbcee)", "rgba(c49040ee)" }, angle = 45 },
            inactive_border = "rgba(1c2840aa)",
        },
    },
})

hl.config({
    decoration = {
        rounding = 10,
        blur = {
            enabled = true,
            size = 7,
            passes = 2,
            new_optimizations = true,
            ignore_opacity = true,
        },
        shadow = {
            enabled = true,
            range = 12,
            render_power = 3,
            color = "rgba(040810ee)",
        },
    },
})

hl.config({
    animations = {
        enabled = true,
    },
})

hl.curve("sargasso", {
    type = "bezier",
    points = { { 0.02, 0.8 }, { 0.05, 1.0 } },
})

hl.animation({ leaf = "windows",     enabled = true, speed = 6,  bezier = "sargasso" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 6,  bezier = "sargasso", style = "popin 80%" })
hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "sargasso" })
hl.animation({ leaf = "fade",        enabled = true, speed = 6,  bezier = "sargasso" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 5,  bezier = "sargasso" })

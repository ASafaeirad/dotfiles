-- Animation curves and tree. (was animation.conf)

hl.config({
    animations = {
        enabled = true,
    },
})

hl.curve("easeInOutSine", { type = "bezier", points = { { 0.37, 0 }, { 0.63, 1 } } })
hl.curve("overshot", { type = "bezier", points = { { 0.13, 0.99 }, { 0.29, 1.1 } } })
hl.curve("easeOutQuart", { type = "bezier", points = { { 0.25, 1 }, { 0.5, 1 } } })
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.22, 1 }, { 0.36, 1 } } })

-- Windows
hl.animation({ leaf = "windows", enabled = true, speed = 2, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2, bezier = "easeOutQuart", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 2, bezier = "easeOutQuart" })

-- Fade
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "easeOutQuart" })
hl.animation({ leaf = "border", enabled = true, speed = 3, bezier = "easeOutQuint" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "easeOutQuart", style = "slide" })

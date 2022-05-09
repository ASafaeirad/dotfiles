local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")
local colors = require("modules.colors")
local shape = require("gears.shape")

require("math")
require("string")

local Volume = {}
Volume.__index = Volume

local function run(command)
    local prog = io.popen(command)
    local result = prog:read('*all')
    prog:close()
    return result
end

function Volume:new(args)
    local obj = setmetatable({}, Volume)
    obj.step = args.step or 5
    obj.device = args.device or "Master"
    obj.color = args.color or "white"
    obj.mute_color = args.mute_color or "red"

    obj.widget = wibox.widget {
        max_value = 100,
        thickness = 2,
        start_angle = 4.71238898, -- 2pi*3/4
        forced_height = 12,
        forced_width = 12,
        paddings = 8,
        colros = { obj.color },
        widget = wibox.container.arcchart,
    }

    -- Add a tooltip to the imagebox
    obj.tooltip = awful.tooltip({
        timer_function = function()
            return obj:update_tooltip()
        end
    })
    obj.tooltip:add_to_object(obj.widget)

    -- Check the volume every 5 seconds
    obj.timer = timer({ timeout = 5 })
    obj.timer:connect_signal("timeout", function()
        obj:update()
    end)
    obj.timer:start()

    obj:update()

    return obj
end

function Volume:update_tooltip()
    return string.sub(self:get_volume(), 0, 2) .. "% Volume"
end

function Volume:update()
    local volume = self:get_volume()
    local is_muted = self:is_muted()

    if is_muted then
        self.widget.colors = { self.mute_color }
        self.widget.value = volume
    else
        self.widget.colors = { self.color }
        self.widget.value = volume
    end
end

function Volume:is_muted()
    local result = run("amixer get " .. self.device)
    return string.find(result, "%[off%]")
end

function Volume:get_volume()
    local result = run("amixer get " .. self.device)
    return string.gsub(string.match(result, "%[%d*%%%]"), "%D", "")
end

return Volume:new({
    step = 10,
    mute_color = colors.error,
    color = colors.fg
})

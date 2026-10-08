---@diagnostic disable: undefined-global

------------------------------------------------------------------------
-- Hammerspoon Configuration
------------------------------------------------------------------------

hs.window.animationDuration = 0

local hyper = { "ctrl", "alt", "cmd", "shift" }


------------------------------------------------------------------------
-- Window helpers
------------------------------------------------------------------------

local function moveTo(x, y, w, h)
    local win = hs.window.focusedWindow()
    if not win then return end
    local screen = win:screen():frame()
    win:setFrame({
        x = screen.x + screen.w * x,
        y = screen.y + screen.h * y,
        w = screen.w * w,
        h = screen.h * h
    })
end

local function moveToNextScreen()
    local win = hs.window.focusedWindow()
    if not win then return end
    local nextScreen = win:screen():next()
    win:moveToScreen(nextScreen, true, true)
    win:centerOnScreen(nextScreen)
end


------------------------------------------------------------------------
-- Window positions
------------------------------------------------------------------------

local pos = {
    fullscreen  = { 0, 0, 1, 1 },
    topHalf     = { 0, 0, 1, 0.5 },
    bottomHalf  = { 0, 0.5, 1, 0.5 },
    leftHalf    = { 0, 0, 0.5, 1 },
    rightHalf   = { 0.5, 0, 0.5, 1 },
    topLeft     = { 0, 0, 0.5, 0.5 },
    topRight    = { 0.5, 0, 0.5, 0.5 },
    bottomLeft  = { 0, 0.5, 0.5, 0.5 },
    bottomRight = { 0.5, 0.5, 0.5, 0.5 },
    centered    = { 0.125, 0.125, 0.75, 0.75 },
    squeezeL    = { 0, 0.125, 0.5, 0.75 },
    squeezeR    = { 0.5, 0.125, 0.5, 0.75 },
}


------------------------------------------------------------------------
-- Key bindings
------------------------------------------------------------------------

hs.hotkey.bind(hyper, "O", function() moveTo(table.unpack(pos.fullscreen)) end)
hs.hotkey.bind(hyper, "H", function() moveTo(table.unpack(pos.leftHalf)) end)
hs.hotkey.bind(hyper, "J", function() moveTo(table.unpack(pos.bottomHalf)) end)
hs.hotkey.bind(hyper, "K", function() moveTo(table.unpack(pos.topHalf)) end)
hs.hotkey.bind(hyper, "L", function() moveTo(table.unpack(pos.rightHalf)) end)
hs.hotkey.bind(hyper, "Y", function() moveTo(table.unpack(pos.topLeft)) end)
hs.hotkey.bind(hyper, "U", function() moveTo(table.unpack(pos.topRight)) end)
hs.hotkey.bind(hyper, "N", function() moveTo(table.unpack(pos.bottomLeft)) end)
hs.hotkey.bind(hyper, "M", function() moveTo(table.unpack(pos.bottomRight)) end)
hs.hotkey.bind(hyper, "P", function() moveTo(table.unpack(pos.centered)) end)
hs.hotkey.bind(hyper, "[", function() moveTo(table.unpack(pos.squeezeL)) end)
hs.hotkey.bind(hyper, "]", function() moveTo(table.unpack(pos.squeezeR)) end)

hs.hotkey.bind(hyper, "1", moveToNextScreen)


------------------------------------------------------------------------
-- Spotify controls
------------------------------------------------------------------------

local function spotify(cmd)
    if not hs.application.find("Spotify") then return end
    hs.osascript.applescript(string.format([[
    tell application "Spotify"
      %s
    end tell
  ]], cmd))
end

hs.hotkey.bind(hyper, "space", function() spotify("playpause") end)
hs.hotkey.bind(hyper, ";", function() spotify("previous track") end)
hs.hotkey.bind(hyper, "'", function() spotify("next track") end)


------------------------------------------------------------------------
-- Quit editors when their last window closes
------------------------------------------------------------------------

-- `c` runs one editor process per dev context, all sharing a bundle ID, and
-- AltTab mishandles a windowless one (Cmd+Q on it quits every instance). So
-- quit each process once it has no windows left. hs.window.list asks the
-- window server, which sees windows on every Space, unlike hs.window.
local quitBundleIDs = { "com.microsoft.VSCode", "com.todesktop.230313mzl4w4u92" }
local quitLog = hs.logger.new("lastwin", "info")
local hadWindows, emptyChecks = {}, {}

local function windowCounts()
    local counts = {}
    for _, w in ipairs(hs.window.list(true) or {}) do
        local b = w.kCGWindowBounds or {}
        -- Layer 0 is normal app windows; skip tiny offscreen helpers
        if w.kCGWindowLayer == 0 and (b.Width or 0) >= 200 and (b.Height or 0) >= 150 then
            local pid = w.kCGWindowOwnerPID
            counts[pid] = (counts[pid] or 0) + 1
        end
    end
    return counts
end

local function quitEmptyEditors()
    local counts = windowCounts()
    for _, id in ipairs(quitBundleIDs) do
        for _, app in ipairs(hs.application.applicationsForBundleID(id)) do
            local pid = app:pid()
            if (counts[pid] or 0) > 0 then
                hadWindows[pid], emptyChecks[pid] = true, 0
            elseif hadWindows[pid] then
                -- Wait for two empty checks in a row so a reload doesn't count
                emptyChecks[pid] = (emptyChecks[pid] or 0) + 1
                if emptyChecks[pid] >= 2 then
                    quitLog.i(string.format("no windows left, quitting %s pid %d", app:name(), pid))
                    hadWindows[pid], emptyChecks[pid] = nil, nil
                    app:kill()
                end
            end
        end
    end
end

-- Global so the timer isn't garbage collected
quitEditorsTimer = hs.timer.doEvery(0.5, quitEmptyEditors)

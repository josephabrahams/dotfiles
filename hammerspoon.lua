-------------------------------------------------------------------------------
-- Hammerspoon Configuration
-------------------------------------------------------------------------------

hs.window.animationDuration = 0

local hyper = {"ctrl", "alt", "cmd", "shift"}


-------------------------------------------------------------------------------
-- Window helpers
-------------------------------------------------------------------------------

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


-------------------------------------------------------------------------------
-- Window positions
-------------------------------------------------------------------------------

local pos = {
  fullscreen  = {0, 0, 1, 1},
  topHalf     = {0, 0, 1, 0.5},
  bottomHalf  = {0, 0.5, 1, 0.5},
  leftHalf    = {0, 0, 0.5, 1},
  rightHalf   = {0.5, 0, 0.5, 1},
  topLeft     = {0, 0, 0.5, 0.5},
  topRight    = {0.5, 0, 0.5, 0.5},
  bottomLeft  = {0, 0.5, 0.5, 0.5},
  bottomRight = {0.5, 0.5, 0.5, 0.5},
  centered    = {0.125, 0.125, 0.75, 0.75},
  squeezeL    = {0, 0.125, 0.5, 0.75},
  squeezeR    = {0.5, 0.125, 0.5, 0.75},
}


-------------------------------------------------------------------------------
-- Key bindings
-------------------------------------------------------------------------------

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


-------------------------------------------------------------------------------
-- Spotify controls
-------------------------------------------------------------------------------

local function spotify(cmd)
  hs.osascript.applescript(string.format([[
    tell application "Spotify"
      %s
    end tell
  ]], cmd))
end

hs.hotkey.bind(hyper, "space", function() spotify("playpause") end)
hs.hotkey.bind(hyper, ";",     function() spotify("previous track") end)
hs.hotkey.bind(hyper, "'",     function() spotify("next track") end)

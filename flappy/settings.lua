local push = require 'push'
local gamestate = require 'gamestate'
local background = require 'background'
local game = require 'game'

local settings = {}

local function parseMousePos (x, y)
  if x >= 190 and x <= 350 and y >= 146 and y <= 168 then return 0 end
  if x >= 190 and x <= 350 and y >= 176 and y <= 198 then return 1 end
  if x >= 190 and x <= 350 and y >= 206 and y <= 228 then return 2 end
  return nil
end

function settings:enter ()
  self.idx = 0
end

function settings:toggleSounds ()
  if BackgroundMusic:isPlaying() then
    BackgroundMusic:stop()
    BackgroundMusic:setLooping(false)
  elseif love.audio.getVolume() == 1 then
    love.audio.setVolume(0)
  else
    BackgroundMusic:play()
    BackgroundMusic:setLooping(true)
    love.audio.setVolume(1)
  end
end

function settings:select (idx)
  if idx == 0 then
    push:switchFullscreen(1280, 720)
  elseif idx == 1 then
    self:toggleSounds()
  elseif idx == 2 then
    gamestate.pop()
  end
end

function settings:keypressed (key)
  if key == 'escape' then
    gamestate.pop()
  elseif key == 'up' then
    Sounds.cursor:play()
    self.idx = self.idx - 1
  elseif key == 'down' then
    Sounds.cursor:play()
    self.idx = self.idx + 1
  elseif key == 'return' or key == 'kpenter' then
    self:select (self.idx)
  end

  if self.idx < 0 then self.idx = 2 end
  if self.idx > 2 then self.idx = 0 end
end

function settings:mousepressed (x, y, button)
  local posX, posY = push:toGame(x, y)
  if posX and button == 1 then
    local idx = parseMousePos(posX, posY)
    if idx then self:select(idx) end
  end
end

function settings:mousemoved (x, y)
  local posX, posY = push:toGame(x, y)
  if posX then
    local idx = parseMousePos(posX, posY)
    if idx and idx ~= self.idx then
      self.idx = idx
      Sounds.cursor:play()
    end
  end
end

function settings:update (dt)
  background:update(dt)
end

function settings:draw ()
  push:start()
  background:draw()

  love.graphics.setFont(Fonts.large)
  love.graphics.printf('Flappy Duck', 0, 30, WIDTH, 'center')

  love.graphics.setFont(Fonts.small)
  love.graphics.printf('Settings', 0, 90, WIDTH, 'center')

  love.graphics.setFont(Fonts.medium)
  love.graphics.printf('Toggle Fullscreen', 200, 150, WIDTH, 'left')

  if BackgroundMusic:isPlaying() then
    love.graphics.printf('Music & Effects', 200, 180, WIDTH, 'left')
  elseif love.audio.getVolume() == 1 then
    love.graphics.printf('Effects Only', 200, 180, WIDTH, 'left')
  else
    love.graphics.printf('No Sounds', 200, 180, WIDTH, 'left')
  end

  love.graphics.printf('Go Back', 200, 210, WIDTH, 'left')

  love.graphics.printf('>', 180, 150+self.idx*30, WIDTH, 'left')

  push:finish()
end

return settings

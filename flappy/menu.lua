local push = require 'push'
local gamestate = require 'gamestate'
local background = require 'background'
local settings = require 'settings'
local game = require 'game'

local menu = { idx = 0 }

local function parseMousePos (x, y)
  if x >= 190 and x <= 350 and y >= 146 and y <= 168 then return 0 end
  if x >= 190 and x <= 350 and y >= 176 and y <= 198 then return 1 end
  if x >= 190 and x <= 350 and y >= 206 and y <= 228 then return 2 end
  return nil
end

function menu:enter ()
  background:setPaused(false)
end

function menu:select (idx)
  if idx == 0 then
    gamestate.push(game)
  elseif idx == 1 then
    gamestate.push(settings)
  elseif idx == 2 then
    love.event.quit()
  end
end

function menu:keypressed (key)
  if key == 'escape' then
    love.event.quit()
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

function menu:mousepressed (x, y, button)
  local posX, posY = push:toGame(x, y)
  if posX and button == 1 then
    local idx = parseMousePos(posX, posY)
    if idx then self:select(idx) end
  end
end

function menu:mousemoved (x, y)
  local posX, posY = push:toGame(x, y)
  if posX then
    local idx = parseMousePos(posX, posY)
    if idx and idx ~= self.idx then
      self.idx = idx
      Sounds.cursor:play()
    end
  end
end

function menu:update (dt)
  background:update(dt)
end

function menu:draw ()
  push:start()
  background:draw()

  love.graphics.setFont(Fonts.large)
  love.graphics.printf('Flappy Duck', 0, 30, WIDTH, 'center')

  love.graphics.setFont(Fonts.small)
  love.graphics.printf('by', 0, 80, WIDTH, 'center')
  love.graphics.printf('Iury Ramos Garcia', 0, 90, WIDTH, 'center')

  love.graphics.setFont(Fonts.medium)
  love.graphics.printf('New Game', 200, 150, WIDTH, 'left')
  love.graphics.printf('Settings', 200, 180, WIDTH, 'left')
  love.graphics.printf('Quit Game', 200, 210, WIDTH, 'left')

  love.graphics.printf('>', 180, 150+self.idx*30, WIDTH, 'left')

  love.graphics.setFont(Fonts.small)
  love.graphics.printf('v1.0 ( 2021 )', 20, HEIGHT-32, WIDTH, 'left')
  love.graphics.printf('Max Score: ' .. tostring(MaxScore), 0, HEIGHT-32, WIDTH-20, 'right')

  push:finish()
end

return menu

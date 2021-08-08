Gamestate = require 'gamestate'
Push = require 'push'

local menu = {}

function menu:init ()
  self.gameStarted = false
end

function menu:enter ()
  self.idx = self.gameStarted and 0 or 1
end

function menu:draw ()
  Push:start()

  love.graphics.setFont(Fonts.large)
  love.graphics.printf('PiNG!', 0, 12, WIDTH, 'center')

  love.graphics.setFont(Fonts.small)
  love.graphics.printf('by', 0, 55, WIDTH, 'center')
  love.graphics.printf('Iury Ramos Garcia', 0, 70, WIDTH, 'center')

  love.graphics.setFont(Fonts.medium)

  if self.gameStarted then
    love.graphics.printf('Continue', 110, 105, 100, 'left')
  end

  love.graphics.printf('New Game', 110, 130, 200, 'left')
  love.graphics.printf('Toggle Fullscreen', 110, 155, 200, 'left')
  love.graphics.printf('Quit Game', 110, 180, 200, 'left')

  love.graphics.printf('>', 90, 105 + self.idx * 25, 100, 'left')

  love.graphics.setFont(Fonts.small)
  love.graphics.printf('v1.0 ( 2021 )', 10, 220, 100, 'left')

  Push:finish()
end

function menu:keypressed (key)
  if key == 'escape' then
    return love.event.quit()
  end

  if key == 'up' or key == 'w' then
    Sounds.paddleHit:play()
    self.idx = self.idx - 1
  end

  if key == 'down' or key == 's' then
    Sounds.paddleHit:play()
    self.idx = self.idx + 1
  end

  if key == 'enter' or key == 'return' then
    if self.idx == 0 then
      Gamestate.switch(Game)

    elseif self.idx == 1 then
      self.gameStarted = true
      Game:reset()
      Gamestate.switch(Game)

    elseif self.idx == 2 then
      Push:switchFullscreen(640, 480)
      love.mouse.setVisible(not love.window.getFullscreen())

    elseif self.idx == 3 then
      return love.event.quit()
    end
  end

  local minIdx = self.gameStarted and 0 or 1
  local maxIdx = 3

  if self.idx < minIdx then
    self.idx = maxIdx
  end

  if self.idx > maxIdx then
    self.idx = minIdx
  end
end

return menu

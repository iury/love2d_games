Class = require 'class'

local player = Class{}

function player:init (x, y, keyUp, keyDown)
  self.speed = 240
  self.x = x
  self.y = y
  self.keyUp = keyUp
  self.keyDown = keyDown
end

function player:update (dt)
  if love.keyboard.isDown(self.keyUp) then
    self.y = self.y - dt*self.speed
  end

  if love.keyboard.isDown(self.keyDown) then
    self.y = self.y + dt*self.speed
  end

  self.y = math.max(0, math.min(HEIGHT-24, self.y))
end

function player:draw ()
  love.graphics.rectangle('fill', self.x, self.y, 2, 24)
end

return player

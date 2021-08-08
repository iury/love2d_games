local Class = require 'class'
local HC = require 'HC'

local Pipe = Class{}

local sprite = love.graphics.newImage('assets/pipe.png')
local SPRITE_CENTER_WIDTH = sprite:getWidth()/2
local SPRITE_CENTER_HEIGHT = sprite:getHeight()/2

function Pipe:init ()
  self.x = WIDTH
  self.y = love.math.random(0, HEIGHT)
  self.gap = love.math.random(HEIGHT*0.3, HEIGHT*0.5)
  if self.y + self.gap > HEIGHT then self.y = self.y - self.gap end
  if self.y <= 0 then self.y = 1 end
  self.rect1 = HC.rectangle(WIDTH, 0, 70, self.y)
  self.rect2 = HC.rectangle(self.x, self.y+self.gap, 70, 288)
end

function Pipe:update (dt)
  self.x = self.x - PIPE_SPEED*dt
  if self.rect1 then self.rect1:moveTo(self.x+35, self.y/2) end
  if self.rect2 then self.rect2:moveTo(self.x+35, self.y+self.gap+144) end
end

function Pipe:draw ()
  love.graphics.draw(sprite, self.x, self.y+self.gap, 0, 1, 1)
  love.graphics.draw(sprite, self.x, self.y, 0, 1, -1)
  --love.graphics.polygon('line', self.rect1:unpack())
  --love.graphics.polygon('line', self.rect2:unpack())
end

function Pipe:cleanup ()
  if self.rect1 then
    HC.remove(self.rect1)
    self.rect1 = nil
  end

  if self.rect2 then
    HC.remove(self.rect2)
    self.rect2 = nil
  end
end

return Pipe

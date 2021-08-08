local Class = require 'class'
local timer = require 'timer'
local HC = require 'HC'

local duck = Class{}

local sprite = love.graphics.newImage('assets/duck.png')
local SPRITE_CENTER_WIDTH = sprite:getWidth()/2
local SPRITE_CENTER_HEIGHT = sprite:getHeight()/2

function duck:init ()
  -- duck's collision polygon
  self.polygon = HC.polygon(3,3, 13,1, 28,1, 34,7, 34,12, 38,15, 38,20, 36,22, 25,22, 24,24, 11,24, 1,16)
  self:reset()
end

function duck:reset ()
  self.dy = 0
  self.y = HEIGHT/4
  self.polygon:setRotation(0)
  self.polygon:moveTo(WIDTH/8, HEIGHT/4)
end

function duck:update (dt)
  self.dy = self.actionPressed and -240 or self.dy + 1280*dt
  self.y = math.max(15, math.min(HEIGHT-24, self.y + self.dy*dt))
  self.polygon:setRotation(math.rad(math.max(-45, math.min(60, self.dy/5))))
  self.polygon:moveTo(WIDTH/8, self.y)
end

function duck:performAction ()
  self.actionPressed = true
  Sounds.wing:seek(0)
  Sounds.wing:play()
  -- ignores action key if player holds it
  if self.handler then timer.cancel(self.handler) end
  self.handler = timer.after(0.5, function () self.actionPressed = false end)
end

function duck:keypressed (key, _, isrepeat)
  if not isrepeat and love.keyboard.isActionKey(key) then
    self:performAction()
  end
end

function duck:keyreleased (key)
  if love.keyboard.isActionKey(key) then
    self.actionPressed = false
  end
end

function duck:mousepressed ()
  self:performAction()
end

function duck:mousereleased ()
  self.actionPressed = false
end

function duck:draw ()
  love.graphics.draw(sprite, WIDTH/8, self.y, self.polygon:rotation(), 1, 1, SPRITE_CENTER_WIDTH, SPRITE_CENTER_HEIGHT)
  --love.graphics.polygon('line', self.polygon:unpack())
end

return duck()

local Class = require 'class'

local background = Class{}

local BACKGROUND_LOOPING_POINT = 413

local assets = {
  background = love.graphics.newImage('assets/background.png'),
  ground = love.graphics.newImage('assets/ground.png'),
}

function background:init ()
  self:reset()
end

function background:setPaused (paused)
  self.paused = paused
end

function background:reset ()
  self.backgroundScroll = 0
  self.groundScroll = 0
  self.paused = true
end

function background:update (dt)
  if not self.paused then
    self.backgroundScroll = (self.backgroundScroll + PIPE_SPEED/3 * dt) % BACKGROUND_LOOPING_POINT
    self.groundScroll = (self.groundScroll + PIPE_SPEED * dt) % WIDTH
  end
end

function background:draw ()
  self:drawBackground()
  self:drawGround()
end

function background:drawBackground ()
  love.graphics.draw(assets.background, -self.backgroundScroll, 0)
end

function background:drawGround ()
  love.graphics.draw(assets.ground, -self.groundScroll, HEIGHT-assets.ground:getHeight())
end

return background()

Class = require 'class'

local ball = Class{}

function ball:reset (x, y, direction)
  self.x = x
  self.y = y
  self.direction = direction
  self.dx = love.math.random(140, 200)
  self.dy = love.math.random(-150, 150)
end

function ball:revert ()
  self.dx = self.dx * 1.03
  self.dy = love.math.random(10, 150) * (self.dy < 0 and -1 or 1)
  self.direction = -self.direction
end

function ball:update (dt)
  self.x = self.x + self.direction * self.dx * dt
  self.y = math.max(0, math.min(HEIGHT-4, self.y + self.dy * dt))
  if self.y == 0 or self.y == HEIGHT-4 then
    self.dy = -self.dy
    Sounds.wallHit:play()
  end
end

function ball:collides(player)
  local function ccw(a,b,c)
    return (c.y-a.y) * (b.x-a.x) > (b.y-a.y) * (c.x-a.x)
  end
  local b = { x = self.x + 4 * self.direction, y = self.y }
  local c = { x = player.x, y = player.y }
  local d = { x = player.x, y = player.y+24 }
  return ccw(self, c, d) ~= ccw(b, c, d) and ccw(self, b, c) ~= ccw(self, b, d)
end

function ball:draw ()
  love.graphics.rectangle('fill', self.x, self.y, 4, 4)
end

return ball

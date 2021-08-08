local powerup = Class{ type = 'powerup' }

local Quads = {
  catch = {},
  duplicate = {},
  enlarge = {},
  laser = {},
  life = {},
  slow = {},
}

for i = 1, 8 do Quads.catch[i] = love.graphics.newQuad(38*(i-1), 0, 38, 19, Graphics.powerup:getDimensions()) end
for i = 1, 8 do Quads.duplicate[i] = love.graphics.newQuad(38*(i-1), 19, 38, 19, Graphics.powerup:getDimensions()) end
for i = 1, 8 do Quads.enlarge[i] = love.graphics.newQuad(38*(i-1), 19*2, 38, 19, Graphics.powerup:getDimensions()) end
for i = 1, 8 do Quads.laser[i] = love.graphics.newQuad(38*(i-1), 19*3, 38, 19, Graphics.powerup:getDimensions()) end
for i = 1, 8 do Quads.life[i] = love.graphics.newQuad(38*(i-1), 19*4, 38, 19, Graphics.powerup:getDimensions()) end
for i = 1, 8 do Quads.slow[i] = love.graphics.newQuad(38*(i-1), 19*5, 38, 19, Graphics.powerup:getDimensions()) end

function powerup:init (power, x, y)
  self.destroyed = false
  self.power = power
  self.x = x
  self.y = y
  self._dieHnd = Signal.register('die', function () self:destroy() end)
  self:animate()
  World:add(self, self.x, self.y, 38, 19)
end

function powerup:animate ()
  self.tween = 1
  self._tweenTmr = Timer.tween(1, self, { tween = 8 }, 'linear', function() self:animate() end)
end

function powerup:update (dt)
  if self.destroyed then return end

  local _, actualY, cols, len = World:move(self, self.x, self.y+180*dt, function (_, other)
    return (other.type == 'paddle' or other.type == 'deadzone') and 'touch' or nil
  end)
  self.y = actualY

  if len > 0 then
    for i = 1, len do
      local sprite = cols[i].other
      if sprite.type == 'paddle' then Signal.emit('powerup', self.power) end
      Signal.emit('canDropPowerup')
      self:destroy()
    end
  end
end

function powerup:render ()
  if self.destroyed then return end
  love.graphics.draw(Graphics.powerup, Quads[self.power][math.floor(self.tween)], self.x, self.y)
end

function powerup:destroy ()
  self.destroyed = true
  if World:hasItem(self) then World:remove(self) end
  if self._tweenTmr then Timer.cancel(self._tweenTmr); self._tweenTmr = nil end
  if self._dieHnd then Signal.remove('die', self._dieHnd); self._dieHnd = nil end
end

return powerup

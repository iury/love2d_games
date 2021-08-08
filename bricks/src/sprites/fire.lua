local fire = Class{ type = 'fire' }

function fire:init (x)
  self.destroyed = false
  self.x = x
  self.y = VIRTUAL_HEIGHT-70
  self.dy = -1440
  self._dieHnd = Signal.register('die', function () self:destroy() end)
  World:add(self, self.x, self.y, 6, 15)
end

function fire:update (dt)
  if self.destroyed then return end
  self.y = self.y + self.dy*dt

  local _, _, cols, len = World:move(self, self.x, self.y, function (_, other)
    return (other.type == 'brick' or other.type == 'edge') and 'touch' or nil
  end)

  if len > 0 then
    for i = 1, len do
      local sprite = cols[i].other
      if sprite.type == 'brick' then sprite:hit() end
      self:destroy()
    end
  end
end

function fire:render ()
  if self.destroyed then return end
  love.graphics.draw(Graphics.bullet, self.x, self.y)
end

function fire:destroy ()
  self.destroyed = true
  if World:hasItem(self) then World:remove(self) end
  if self._dieHnd then Signal.remove('die', self._dieHnd); self._dieHnd = nil end
end

return fire

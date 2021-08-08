local ball = Class{ type = 'ball' }

function ball:init (x, y)
  self.destroyed = false
  if x == nil then
    self.x = love.math.random(1,2) == 1 and 258 or 288
    self.y = VIRTUAL_HEIGHT-70
    self.dx = love.math.random(90, 360) * (self.x == 258 and -1 or 1)
    self.dy = -180
    self.catched = true
  else
    self.x = x
    self.y = y
    self.dx = love.math.random(-180, 180)
    self.dy = -180
    self.catched = false
  end

  self._dieHnd = Signal.register('die', function () self:destroy() end)

  self._moveHnd = Signal.register('move', function (dx)
    if self.catched then
      self.x = self.x + dx
      World:update(self, self.x, self.y)
    end
  end)

  Timer.after(0.01, function ()
    if self.destroyed then return end
    self._pwrHnd = Signal.register('powerup', function (power)
      if power == 'catch' then
        self.catchable = true
        Sounds.up:seek(0)
        Sounds.up:play()
      elseif power == 'slow' then
        self.catchable = false
        self.catched = false
        self.dy = 180 * (self.dy < 0 and -1 or 1)
      elseif power == 'laser' or power == 'enlarge' or power == 'duplicate' then
        self.catchable = false
        self.catched = false
      end
    end)
  end)

  World:add(self, self.x, self.y, 10, 10)
end

function ball:update (dt)
  if self.destroyed then return end

  if self.catched then
    if Input:pressed('action') then
      self.catched = false
      Sounds.catch:play()
    end
  else
    self.x = self.x + self.dx*dt
    self.y = self.y + self.dy*dt

    local actualX, actualY, cols, len = World:move(self, self.x, self.y, function (_, other)
      if other.type == 'edge' or other.type == 'paddle' or other.type == 'brick' then
        return 'bounce'
      elseif other.type == 'deadzone' then
        return 'slide'
      else
        return nil
      end
    end)

    self.x = actualX
    self.y = actualY

    for i = 1, len do
      local sprite = cols[i].other

      if sprite.type == 'deadzone' then
        self:destroy()
        Signal.emit('deadball')
      elseif sprite.type == 'paddle' then
        self.dx = sprite:calculateDelta(actualX)
        if self.dy > 0 then self.dy = -self.dy end
        if self.catchable then
          self.catched = true
          Sounds.select:play()
        else
          Sounds.up:play()
        end
      elseif sprite.type == 'brick' then
        Signal.emit('points', sprite.points)
        sprite:hit()
        self.dy = math.min(540, math.max(-540, self.dy * 1.1))
      end

      if cols[i].bounce then
        if sprite.type ~= 'paddle' then
          if (self.dx < 0 and cols[i].bounce.x > cols[i].touch.x) or (self.dx > 0 and cols[i].bounce.x < cols[i].touch.x) then self.dx = -self.dx end
          if (self.dy < 0 and cols[i].bounce.y > cols[i].touch.y) or (self.dy > 0 and cols[i].bounce.y < cols[i].touch.y) then self.dy = -self.dy end
        end
      end
    end
  end
end

function ball:render ()
  if self.destroyed then return end
  love.graphics.draw(Graphics.ball, self.x, self.y)
end

function ball:destroy ()
  self.destroyed = true
  if World:hasItem(self) then World:remove(self) end
  if self._pwrHnd then Signal.remove('powerup', self._pwrHnd); self._pwrHnd = nil end
  if self._dieHnd then Signal.remove('die', self._dieHnd); self._dieHnd = nil end
  if self._moveHnd then Signal.remove('move', self._moveHnd); self._moveHnd = nil end
end

return ball

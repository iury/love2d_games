local sprite = BaseSprite:extend({ type = 'goomba', enemy = true, collision = 'slide' })

function sprite:constructor (x, y)
  self.destroyed = false
  self.frozen = false
  self.x = x
  self.y = y
  self.dx = 0
  self.dy = 0

  self.behavior = Behavior {
    default = {
      { duration = 0, after = 'walk' },
    },
    walk = {
      { duration = 0.2, quad = Quads.sprites[1][7] },
      { duration = 0.2, quad = Quads.sprites[1][6] },
    },
    stomp = {
      { duration = 1, quad = Quads.sprites[1][8] },
    },
  }

  self.handler = Event.on('dead', function () self.frozen = true end)
  GlobalState.world:add(self, self.x, self.y, 16, 16)
end

function sprite:stomp (touch, kicked)
  if kicked then
    Sounds.kick:seek(0)
    Sounds.kick:play()
  else
    Sounds.stomp:seek(0)
    Sounds.stomp:play()
  end
  self.behavior:setState('stomp')
  self.frozen = true
  self.collision = false
  Timer.after(0.5, function () self:destroy() end)
end

function sprite:update (dt)
  if self.destroyed or self.frozen then return end
  self.behavior:update(dt)
  if GlobalState.onFrame then
    if not self.visible and -GlobalState.tx + VIRTUAL_WIDTH + 16 > self.x then
      self.visible = true
      self.dx = -0x1c8
      self.dy = 0x700
    end

    local actualX, actualY, cols = GlobalState.world:move(self, self.x+self.dx/1000, self.y+self.dy/1000, function (_, other)
      if other.collision == false then return nil end
      return other.collision or 'slide'
    end)
    self.x = actualX
    self.y = actualY

    for _, col in pairs(cols) do
      if col.type == 'slide' and col.normal.x ~= 0 then self.dx = self.dx * -1 end
      if col.other.type == 'mario' then col.other:hit(self) end
    end

    if self.visible and (self.x < -GlobalState.tx-16 or self.x > -GlobalState.tx + VIRTUAL_WIDTH * 1.5) then self:destroy() end
    if self.x < -16 or self.y > VIRTUAL_HEIGHT + 16 then self:destroy() end
  end
end

function sprite:draw ()
  if self.destroyed then return end
  if self.behavior.frame.quad then
    love.graphics.draw(Graphics.sprites, self.behavior.frame.quad, math.floor(self.x), math.floor(self.y))
  end
end

function sprite:destroy ()
  GlobalState.world:remove(self)
  self.handler:remove()
  self.destroyed = true
end

return sprite

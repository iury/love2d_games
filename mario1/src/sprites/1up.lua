local sprite = BaseSprite:extend({ type = '1up', collision = 'cross' })

function sprite:constructor (x, y, ref)
  self.destroyed = false
  self.visible = false
  self.ref = ref
  self.x = x
  self.y = y+4
  self.dx = 0
  self.dy = 0x700

  self.behavior = Behavior {
    default = {
      { duration = 1, quad = Quads.sprites[11][2] },
    },
  }

  self.handler = Event.on('spawn', function (r)
    if r == self.ref then self:spawn() end
  end)

  GlobalState.world:add(self, self.x, self.y, 16, 16)
end

function sprite:spawn ()
  self.visible = true
  self.direction = GlobalState.facingDirection
  Sounds.powerupAppears:play()
  self.timer = Timer.every(0.05, function ()
    self.y = self.y-1
    GlobalState.world:update(self, self.x, self.y, 16, 16)
    local _, _, _, cnt = GlobalState.world:check(self, self.x, self.y, function (_, other) return other.type == 'block' and 'slide' or nil end)
    if cnt == 0 then
      self.timer:remove()
      self.dx = 0x2ac*self.direction
    end
  end)
end

function sprite:update (dt)
  if self.destroyed then return end
  self.behavior:update(dt)
  if GlobalState.onFrame then
    if self.dx ~= 0 then
      self.x = self.x+self.dx/1000
      self.y = self.y+self.dy/1000

      local actualX, actualY, cols = GlobalState.world:move(self, self.x+self.dx/1000, self.y+self.dy/1000, function (_, other)
        if other.collision == false then return nil end
        return other.collision or 'slide'
      end)

      self.x = actualX
      self.y = actualY

      for _, col in pairs(cols) do
        if col.normal.x ~= 0 then
          if col.type == 'slide' then self.dx = self.dx * -1 end
        end
        if col.other.type == 'mario' then
          Sounds.up:play()
          self:destroy()
        end
      end
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

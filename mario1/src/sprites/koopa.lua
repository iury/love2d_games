local sprite = BaseSprite:extend({ type = 'koopa', enemy = true })

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
      { duration = 0.2, quad = Quads.sprites[2][16], head = Quads.sprites[1][16] },
      { duration = 0.2, quad = Quads.sprites[2][15], head = Quads.sprites[1][15] },
    },
    shell = {
      { duration = 1, quad = Quads.sprites[14][14] },
    },
    stomp = {
      { duration = 8, quad = Quads.sprites[14][14] },
      { duration = 0.5, quad = Quads.sprites[15][14] },
      { duration = 0.5, quad = Quads.sprites[14][14] },
      { duration = 0.5, quad = Quads.sprites[15][14] },
      { duration = 0.5, quad = Quads.sprites[14][14] },
      { duration = 0.5, quad = Quads.sprites[15][14], after = 'wake' },
    },
    wake = {
      {
        duration = 0,
        after = 'walk',
        action = function ()
          self.type = 'koopa'
          self.enemy = true
          self.dx = -0x1c8
        end
      },
    },
  }

  self.handler = Event.on('dead', function () self.frozen = true end)
  GlobalState.world:add(self, self.x, self.y, 16, 16)
end

function sprite:stomp (touch)
  if self.type == 'koopa' then
    self.behavior:setState('stomp')
    Sounds.stomp:seek(0)
    Sounds.stomp:play()
    self.type = 'shell'
    self.enemy = false
    self.dx = 0
  else
    self.behavior:setState('shell')
    Sounds.kick:play()
    if self.dx == 0 then
      self.dx = 0x1000 * (touch.x > self.x and -1 or 1)
      self.enemy = true
    else
      self.dx = 0
      self.enemy = false
    end
  end
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
      if col.normal.x ~= 0 then
        if col.other.type == 'goomba' then
          col.other:stomp(nil, true)
        elseif col.type == 'slide' and col.other.type ~= 'mario' then
          self.dx = self.dx * -1
        end
      end
      if col.other.type == 'mario' and self.enemy then col.other:hit(self) end
    end

    if self.visible and (self.x < -GlobalState.tx-16 or self.x > -GlobalState.tx + VIRTUAL_WIDTH * 1.5) then self:destroy() end
    if self.y > VIRTUAL_HEIGHT + 16 then self:destroy() end
  end
end

function sprite:draw ()
  if self.destroyed then return end
  if self.behavior.frame.quad then
    love.graphics.draw(Graphics.sprites, self.behavior.frame.quad, math.floor(self.x), math.floor(self.y), 0, self.dx > 0 and 1 or -1, 1, self.dx > 0 and 0 or 16, 0)
    if self.behavior.frame.head then
      love.graphics.draw(Graphics.sprites, self.behavior.frame.head, math.floor(self.x), math.floor(self.y)-16, 0, self.dx > 0 and 1 or -1, 1, self.dx > 0 and 0 or 16, 0)
    end
  end
end

function sprite:destroy ()
  GlobalState.world:remove(self)
  self.handler:remove()
  self.destroyed = true
end

return sprite

local sprite = BaseSprite:extend({ type = 'block' })

function sprite:constructor (x, y, visible, ref)
  self.destroyed = false
  self.visible = visible
  self.ref = ref
  self.x = x
  self.y = y
  self.behavior = Behavior {
    default = {
      { duration = 1, quad = Quads.tiles[1][5] },
    },
    solid = {
      { duration = 1, quad = Quads.tiles[1][8] },
    },
  }
  GlobalState.world:add(self, self.x, self.y, 16, 16)
end

function sprite:hit (col, big)
  if col.normal.y == 1 then
    if self.behavior.state == 'default' then
      self.behavior:setState('solid')
      self.visible = true
      if self.ref then
        Event.dispatch('spawn', self.ref)
      else
        Sounds.coin:seek(0)
        Sounds.coin:play()
      end
    else
      Sounds.bump:seek(0)
      Sounds.bump:play()
    end
  end
end

function sprite:update (dt)
  if self.destroyed then return end
  self.behavior:update(dt)
  if GlobalState.onFrame then
  end
end

function sprite:draw ()
  if self.destroyed then return end
  if self.visible and self.behavior.frame.quad then
    love.graphics.draw(Graphics.tiles, self.behavior.frame.quad, self.x, self.y)
  end
end

return sprite

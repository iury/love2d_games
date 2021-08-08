local sprite = BaseSprite:extend({ type = 'coin', collision = 'cross' })

function sprite:constructor (x, y)
  self.destroyed = false
  self.visible = true
  self.x = x
  self.y = y
  self.behavior = Behavior {
    default = {
      { duration = 1, quad = Quads.tiles[4][16] },
      { duration = 0.2, quad = Quads.tiles[5][16] },
      { duration = 0.2, quad = Quads.tiles[6][16] },
    }
  }
  GlobalState.world:add(self, self.x, self.y, 16, 16)
end

function sprite:draw ()
  if self.behavior.frame.quad then
    love.graphics.draw(Graphics.tiles, self.behavior.frame.quad, self.x, self.y)
  end
end

function sprite:destroy ()
  self.destroyed = true
  GlobalState.world:remove(self)
end

return sprite

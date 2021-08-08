local sprite = BaseSprite:extend({ type = 'pipeexit', collision = 'cross' })

function sprite:constructor (x, y)
  self.destroyed = false
  self.x = x
  self.y = y
  GlobalState.world:add(self, self.x, self.y, 16, 16)
end

return sprite

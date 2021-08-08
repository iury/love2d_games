local sprite = BaseSprite:extend({ type = 'wall' })

function sprite:constructor (x, y)
  self.destroyed = false
  self.visible = true
  self.x = x
  self.y = y
  self.behavior = Behavior {
    default = {
      { duration = 1, quad = Quads.tiles[1][2] },
    },
  }
end

function sprite:update (dt)
  self.behavior:update(dt)
  if GlobalState.onFrame then
  end
end

function sprite:draw ()
  if self.behavior.frame.quad then
    love.graphics.draw(Graphics.tiles, self.behavior.frame.quad, self.x, self.y)
  end
end

return sprite

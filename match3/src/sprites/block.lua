local block = Base:extend()

function block:constructor (tx, ty, color, visible)
  self.dissolving = false
  self.destroyed = false
  self.tx = tx
  self.ty = ty
  self.x = 214+33*(tx-1)
  self.y = 12+33*(ty-1)
  self.width = 32
  self.height = 32
  self.color = color
  self.visible = visible ~= false
end

function block:moveTo (tx, ty)
  self.tx = tx
  self.ty = ty
  Timer.tween(0.2, {
    [self] = {
      x = 214+33*(tx-1),
      y = 12+33*(ty-1)
    }
  })
end

function block:dissolve ()
  self.dissolving = true
  Timer.tween(0.2, {
    [self] = {
      width = 1,
      height = 1,
      x = self.x + 15,
      y = self.y + 15
    }
  }):finish(function ()
    self:destroy()
  end)
end

function block:appear ()
  self.visible = true
  self.width = 1
  self.height = 1
  self.x = self.x + 15
  self.y = self.y + 15
  Timer.tween(0.2, {
    [self] = {
      width = 32,
      height = 32,
      x = self.x - 15,
      y = self.y - 15
    }
  })
end

function block:render ()
  if self.destroyed or not self.visible then return end
  love.graphics.draw(Graphics.tiles, Quads[self.color], self.x, self.y, 0, self.width/32, self.height/32)
end

function block:destroy ()
  self.destroyed = true
end

return block

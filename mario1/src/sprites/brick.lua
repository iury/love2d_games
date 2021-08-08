local sprite = BaseSprite:extend({ type = 'brick' })

local ExplosionQuads = {
  love.graphics.newQuad(16, 0, 8, 8, Graphics.tiles:getDimensions()),
  love.graphics.newQuad(24, 0, 8, 8, Graphics.tiles:getDimensions()),
  love.graphics.newQuad(16, 8, 8, 8, Graphics.tiles:getDimensions()),
  love.graphics.newQuad(24, 8, 8, 8, Graphics.tiles:getDimensions()),
}

function sprite:constructor (x, y)
  self.destroyed = false
  self.visible = true
  self.x = x
  self.y = y
  self.behavior = Behavior {
    default = {
      { duration = 1, quad = Quads.tiles[1][15] },
    },
  }
  GlobalState.world:add(self, self.x, self.y, 16, 16)
end

function sprite:hit (col, big)
  if col.normal.y == 1 then
    if big then
      self.exploded = true
      GlobalState.world:remove(self)
      Sounds.brickSmash:seek(0)
      Sounds.brickSmash:play()
      Timer.after(0.3, function () self:destroy() end)
    else
      self.y = self.y-4
      Timer.after(0.1, function () self.y = self.y+4 end)
      Sounds.bump:seek(0)
      Sounds.bump:play()
    end
  end
end

function sprite:update (dt)
  if self.destroyed then return end
  self.behavior:update(dt)
  if GlobalState.onFrame then
    if self.exploded then
      self.dist = (self.dist or 0) + 2
      self.y = self.y-1
    end
  end
end

function sprite:draw ()
  if self.destroyed then return end
  if not self.exploded then
    if self.behavior.frame.quad then
      love.graphics.draw(Graphics.tiles, self.behavior.frame.quad, self.x, self.y)
    end
  else
    love.graphics.draw(Graphics.tiles, ExplosionQuads[1], self.x-self.dist/3, self.y, math.rad(270+self.dist*4))
    love.graphics.draw(Graphics.tiles, ExplosionQuads[2], self.x+8+self.dist/3, self.y, math.rad(self.dist*4))
    love.graphics.draw(Graphics.tiles, ExplosionQuads[3], self.x-self.dist/3, self.y+self.dist/3, math.rad(270+self.dist*4))
    love.graphics.draw(Graphics.tiles, ExplosionQuads[4], self.x+8+self.dist/3, self.y+self.dist/3, math.rad(self.dist*4))
  end
end

return sprite

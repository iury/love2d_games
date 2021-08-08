local sprite = BaseSprite:extend({ type = 'castleflag' })

function sprite:constructor (x, y)
  self.destroyed = false
  self.visible = true
  self.x = x
  self.y = y
  self.behavior = Behavior {
    default = {
      { duration = 1, quad = Quads.sprites[11][10] },
    },
  }
  self.handler = Event.on('stageClear', function ()
    Timer.tween(1, { [self] = { y = self.y-32 } })
  end)
end

function sprite:update (dt)
  self.behavior:update(dt)
  if GlobalState.onFrame then
  end
end

function sprite:draw ()
  if self.behavior.frame.quad then
    love.graphics.draw(Graphics.sprites, self.behavior.frame.quad, math.floor(self.x), math.floor(self.y))
  end
end

function sprite:destroy ()
  self.handler:remove()
  self.destroyed = true
end

return sprite

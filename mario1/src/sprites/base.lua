local base = Base:extend()

function base:constructor ()
  self.destroyed = false
  self.visible = true
end

function base:update (dt)
end

function base:draw ()
end

function base:destroy ()
  self.destroyed = true
end

return base

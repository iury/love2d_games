local edge = Class{ type = 'edge' }

function edge:init (side)
  self.destroyed = false
  self.side = side
  self.x = 0
  self.y = 70
  if side == 'top' then
    self.texture = Graphics.edgeTop
  elseif side == 'left' then
    self.texture = Graphics.edgeLeft
  elseif side == 'right' then
    self.texture = Graphics.edgeRight
    self.x = VIRTUAL_WIDTH-22
  end
  local width, height = self.texture:getDimensions()
  World:add(self, self.x, self.y, width, height)
end

function edge:render ()
  love.graphics.draw(self.texture, self.x, self.y)
end

function edge:update ()
end

function edge:destroy ()
  self.destroyed = true
  if World:hasItem(self) then World:remove(self) end
end

return edge

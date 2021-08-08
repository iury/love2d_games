local deadzone = Class{ type = 'deadzone' }

function deadzone:init ()
  self.destroyed = false
  World:add(self, 0, VIRTUAL_HEIGHT, VIRTUAL_WIDTH, 50)
end

function deadzone:render ()
end

function deadzone:update ()
end

function deadzone:destroy ()
  self.destroyed = true
  if World:hasItem(self) then World:remove(self) end
end

return deadzone

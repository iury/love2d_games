local lives = Class{ type = 'lives' }

function lives:init (count)
  self.destroyed = false
  self.count = count
  self._signal = Signal.register('1up', function () self.count = self.count + 1 end)
end

function lives:update ()
  if self.destroyed then return end
end

function lives:render ()
  if self.destroyed then return end
  for i = 1, math.min(5, self.count-1) do
    love.graphics.draw(Graphics.life, 22+43*(i-1), VIRTUAL_HEIGHT-20)
  end
end

function lives:destroy ()
  self.destroyed = true
  if self._signal then Signal.remove('1up', self._signal); self._signal = nil end
end

return lives

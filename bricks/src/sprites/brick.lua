local brick = Class{ type = 'brick' }

local quads = {
  bricks = {},
  silver = {},
}

for i = 1, 9 do quads.bricks[#quads.bricks+1] = love.graphics.newQuad(43*(i-1), 0, 43, 21, Graphics.bricks:getDimensions()) end
for i = 1, 10 do quads.silver[#quads.silver+1] = love.graphics.newQuad(43*(i-1), 0, 43, 21, Graphics.brickSilver:getDimensions()) end

function brick:init (posX, posY, color)
  self.destroyed = false
  self.tween = 1
  self.x = 22+(posX-1)*39.3846
  self.y = 72+posY*21
  self.color = color
  self.points = color == 0 and 100 or (color == 9 and 50 or 40+color*10)
  self.hp = color == 0 and 2 or (color == 9 and math.huge or 1)
  World:add(self, self.x, self.y, 43*0.89, 21*0.89)
end

function brick:hit ()
  self.hp = self.hp - 1
  if self.hp > 0 then
    Sounds.bounce:seek(0)
    Sounds.bounce:play()
    if self.color == 0 then
      self.tween = 1
      self._tweenTmr = Timer.tween(0.5, self, { tween = 10 }, 'linear', function() self.tween = 1 end)
    end
  else
    Signal.emit('mayDropPowerup', self.x, self.y)
    Sounds.down:seek(0)
    Sounds.down:play()
    self:destroy()
  end
end

function brick:update ()
  if self.destroyed then return end
end

function brick:render ()
  if self.destroyed then return end
  if self.color > 0 then
    love.graphics.draw(Graphics.bricks, quads.bricks[self.color], self.x, self.y, 0, 0.89, 0.89)
  else
    love.graphics.draw(Graphics.brickSilver, quads.silver[math.floor(self.tween)], self.x, self.y, 0, 0.89, 0.89)
  end
end

function brick:destroy ()
  self.destroyed = true
  if World:hasItem(self) then World:remove(self) end
  if self._tweenTmr then Timer.cancel(self._tweenTmr); self._tweenTmr = nil end
end

return brick

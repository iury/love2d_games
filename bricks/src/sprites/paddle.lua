local paddle = Class{ type = 'paddle' }

local quads = {
  materialize = {},
  laser = {},
  enlarge = {},
  pulsate = {},
  pulsateLaser = {},
  pulsateWide = {},
  explode = {},
}

for i = 1, 15 do quads.materialize[#quads.materialize+1] = love.graphics.newQuad(0, 20*(i-1), 79, 20, Graphics.materialize:getDimensions()) end
for i = 1, 16 do quads.laser[#quads.laser+1] = love.graphics.newQuad(0, 20*(i-1), 79, 20, Graphics.laser:getDimensions()) end
for i = 1, 9 do quads.enlarge[#quads.enlarge+1] = love.graphics.newQuad(0, 20*(i-1), 119, 20, Graphics.enlarge:getDimensions()) end
for i = 1, 4 do quads.pulsate[#quads.pulsate+1] = love.graphics.newQuad(0, 20*(i-1), 79, 20, Graphics.pulsate:getDimensions()) end
for i = 1, 4 do quads.pulsateLaser[#quads.pulsateLaser+1] = love.graphics.newQuad(0, 20*(i-1), 79, 20, Graphics.pulsateLaser:getDimensions()) end
for i = 1, 4 do quads.pulsateWide[#quads.pulsateWide+1] = love.graphics.newQuad(0, 20*(i-1), 119, 20, Graphics.pulsateWide:getDimensions()) end
for i = 1, 8 do quads.explode[#quads.explode+1] = love.graphics.newQuad(0, 51*(i-1), 130, 51, Graphics.explode:getDimensions()) end

function paddle:init (state)
  self.destroyed = false
  self.x = 238
  self.y = VIRTUAL_HEIGHT-55
  self.width = 79

  self._dieHnd = Signal.register('die', function () self:setState('explode') end)
  self._pwrHnd = Signal.register('powerup', function (power)
    if power == 'enlarge' then
      Sounds.powerup:play()
      self:setState('enlarge')
    elseif power == 'laser' then
      Sounds.powerup:play()
      self:setState('laser')
    elseif power == 'catch' or power == 'duplicate' then
      if self.laser then self:setState('invertLaser')
      elseif self.width > 79 then self:setState('shrink')
      end
    end
  end)

  World:add(self, self.x, self.y, self.width, 20)
  self:setState(state)
end

function paddle:setState (state)
  self.state = state
  self.freezed = false
  self.laser = false
  self.tween = 1
  self.prevWidth = self.width
  self.width = 79
  if self._tweenTmr then Timer.cancel(self._tweenTmr); self._tweenTmr = nil end

  if state == 'materialize' then
    self._texture = Graphics.materialize
    self._quad = quads.materialize
    self._tweenTmr = Timer.tween(1, self, { tween = 15 }, 'linear', function() self:setState('paddle') end)
  elseif state == 'laser' then
    if self.prevWidth == 119 then self.x = self.x + 20 end
    self._texture = Graphics.laser
    self._quad = quads.laser
    self._tweenTmr = Timer.tween(0.5, self, { tween = 16 }, 'linear', function() self:setState('paddleLaser') end)
  elseif state == 'invertLaser' then
    self._texture = Graphics.laser
    self._quad = quads.laser
    self.tween = 16
    self._tweenTmr = Timer.tween(1, self, { tween = 1 }, 'linear', function() self:setState('paddle') end)
  elseif state == 'enlarge' then
    self.width = 119
    self.x = self.x - 20
    self._texture = Graphics.enlarge
    self._quad = quads.enlarge
    self._tweenTmr = Timer.tween(0.5, self, { tween = 9 }, 'linear', function() self:setState('paddleWide') end)
  elseif state == 'shrink' then
    self.width = 119
    self._texture = Graphics.enlarge
    self._quad = quads.enlarge
    self.tween = 9
    self._tweenTmr = Timer.tween(0.5, self, { tween = 1 }, 'linear', function() self.x = self.x + 20; self:setState('paddle') end)
  elseif state == 'paddle' then
    self._texture = Graphics.paddle
    self._quad = nil
    self._tweenTmr = Timer.after(1, function() self:setState('pulsate') end)
  elseif state == 'paddleLaser' then
    self.laser = true
    self._texture = Graphics.paddleLaser
    self._quad = nil
    self._tweenTmr = Timer.after(1, function() self:setState('pulsateLaser') end)
  elseif state == 'paddleWide' then
    self.width = 119
    self._texture = Graphics.paddleWide
    self._quad = nil
    self._tweenTmr = Timer.after(1, function() self:setState('pulsateWide') end)
  elseif state == 'pulsate' then
    self._texture = Graphics.pulsate
    self._quad = quads.pulsate
    self._tweenTmr = Timer.tween(0.5, self, { tween = 4 }, 'linear', function() self:setState('paddle') end)
  elseif state == 'pulsateLaser' then
    self.laser = true
    self._texture = Graphics.pulsateLaser
    self._quad = quads.pulsateLaser
    self._tweenTmr = Timer.tween(0.5, self, { tween = 4 }, 'linear', function() self:setState('paddleLaser') end)
  elseif state == 'pulsateWide' then
    self.width = 119
    self._texture = Graphics.pulsateWide
    self._quad = quads.pulsateWide
    self._tweenTmr = Timer.tween(0.5, self, { tween = 4 }, 'linear', function() self:setState('paddleWide') end)
  elseif state == 'explode' then
    if self.prevWidth == 119 then self.x = self.x + 20 end
    self.x = self.x - 25
    self.y = self.y - 31
    Sounds.dead:play()
    self.freezed = true
    self._texture = Graphics.explode
    self._quad = quads.explode
    self._tweenTmr = Timer.tween(0.5, self, { tween = 8 }, 'linear', function()
      self._texture = nil
      Timer.after(1, function () Signal.emit('died') end)
    end)
  end

  World:update(self, self.x, self.y, self.width, 20)
end

function paddle:calculateDelta (x)
  return 960*((x-self.x+5)/self.width)-480
end

function paddle:update (dt)
  if self.destroyed then return end

  if not self.freezed then
    self.px = self.x
    local dx = Input:get('move')*dt*VIRTUAL_WIDTH
    self.x = math.max(22, math.min(VIRTUAL_WIDTH-22-self.width, self.x + dx))
    if dx ~= 0 and self.px ~= self.x then
      Signal.emit('move', dx)
      World:update(self, self.x, self.y)
    end

    if self.laser and Input:pressed('action') then
      Signal.emit('fire', self.x)
    end
  end
end

function paddle:render ()
  if self.destroyed then return end

  if self._texture then
    if self._quad then
      love.graphics.draw(self._texture, self._quad[math.floor(self.tween)], self.x, self.y)
    else
      love.graphics.draw(self._texture, self.x, self.y)
    end
  end
end

function paddle:destroy ()
  self.destroyed = true
  if World:hasItem(self) then World:remove(self) end
  if self._tweenTmr then Timer.cancel(self._tweenTmr); self._tweenTmr = nil end
  if self._pwrHnd then Signal.remove('powerup', self._pwrHnd); self._pwrHnd = nil end
  if self._dieHnd then Signal.remove('die', self._dieHnd); self._dieHnd = nil end
end

return paddle

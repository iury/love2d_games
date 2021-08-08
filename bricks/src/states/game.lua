local game = { sprites = {} }

function game:init ()
  self.canDropPowerup = true
  Signal.register('died', function () self:died() end)
  Signal.register('points', function (points) self.score = self.score + points end)

  Signal.register('deadball', function ()
    local hasBall = false
    for _, s in ipairs(self.sprites) do if s.type == 'ball' and not s.destroyed then hasBall = true; break end end
    if not hasBall then Signal.emit('die') end
  end)

  Signal.register('fire', function (x)
    Sounds.fire:seek(0)
    Sounds.fire:play()
    self.sprites[#self.sprites+1] = Fire(x+25)
    self.sprites[#self.sprites+1] = Fire(x+50)
  end)

  Signal.register('powerup', function (power)
    self.currentPowerup = power
    if power == 'life' or power == 'slow' or power == 'duplicate' then self.currentPowerup = nil end

    if power == 'life' then
      self.lives = self.lives + 1
      Sounds.life:play()
      Signal.emit('1up')
    elseif power == 'duplicate' then
      local ball
      for _, s in ipairs(self.sprites) do if s.type == 'ball' then ball = s; break end end
      self.sprites[#self.sprites+1] = Ball(ball.x, ball.y)
      self.sprites[#self.sprites+1] = Ball(ball.x, ball.y)
    end
  end)

  Signal.register('canDropPowerup', function () self.canDropPowerup = true end)
  Signal.register('mayDropPowerup', function (x, y)
    if love.math.random(1, 3) > 1 then return end
    if self.canDropPowerup then
      self.canDropPowerup = false
      local randomPower = function ()
        local x = love.math.random(1, 6)
        if x == 1 then return 'laser'
        elseif x == 2 then return 'slow'
        elseif x == 3 then return 'life'
        elseif x == 4 then return 'enlarge'
        elseif x == 5 then return 'catch'
        elseif x == 6 then return 'duplicate'
        end
      end
      local power = randomPower()
      while self.currentPowerup == power do power = randomPower() end
      self.sprites[#self.sprites+1] = Powerup(power, x, y)
    end
  end)
end

function game:enter ()
  self.score = 0
  self.level = 1
  self.lives = 3
  game:loadLevel()
end

function game:resume (from)
  if from == States.highScores then
    Gamestate.pop()
  end
end

function game:defaultSprites ()
  return {
    Edge('top'),
    Edge('left'),
    Edge('right'),
    Deadzone(),
    Paddle('materialize'),
    Ball(),
    Lives(self.lives)
  }
end

function game:loadLevel ()
  self:cleanup()
  local level = Level.load(self.level)

  if level then
    Sounds.start:play()
    self.background = level.background
    self.sprites = game:defaultSprites()

    for posY, line in ipairs(level.lines) do
      for posX, brick in ipairs(line) do
        if brick ~= -1 then
          self.sprites[#self.sprites+1] = Brick(posX, posY, brick)
        end
      end
    end

  elseif self.level == 1 then
    error('Level file not found')

  else
    self:gameOver()
  end
end

function game:died ()
  self.lives = self.lives - 1
  self.currentPowerup = nil
  self.canDropPowerup = true

  if self.lives == 0 then
    self:gameOver()
  else
    local sprites = game:defaultSprites()
    for _, sprite in ipairs(self.sprites) do
      if sprite.type == 'brick' then
        sprites[#sprites+1] = sprite
      else
        sprite:destroy()
      end
    end
    self.sprites = sprites
  end
end

function game:gameOver ()
  self:cleanup()
  Sounds.gameEnd:play()
  States.highScores:record(self.score)
  Gamestate.push(States.highScores)
end

function game:update (dt)
  if Input:pressed('pause') then
    Gamestate.push(States.paused)
  end

  local sprites, hasBricks = {}, false
  for _, sprite in ipairs(self.sprites) do
    sprite:update(dt)
    if not sprite.destroyed then
      sprites[#sprites+1] = sprite
      if sprite.type == 'brick' and sprite.color ~= 9 then hasBricks = true end
    end
  end
  self.sprites = sprites

  if not hasBricks then
    self.score = self.score + 10000
    self.level = self.level + 1
    self:loadLevel()
  end
end

function game:render ()
  love.graphics.setFont(Fonts.score)
  love.graphics.setColor(1,0,0)
  love.graphics.printf('Score', 0, 20, VIRTUAL_WIDTH-20, 'right')
  love.graphics.setColor(1,1,1)
  love.graphics.printf(tostring(self.score), 0, 45, VIRTUAL_WIDTH-20, 'right')

  love.graphics.setColor(unpack(BackgroundColors[self.background]))
  love.graphics.rectangle('fill', 0, 70, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  love.graphics.setColor(1,1,1)

  for _, sprite in ipairs(self.sprites) do sprite:render() end
end

function game:cleanup ()
  for _, sprite in ipairs(self.sprites) do sprite:destroy() end
  self.sprites = {}
end

return game

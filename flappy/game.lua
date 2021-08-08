local HC = require 'HC'
local push = require 'push'
local timer = require 'timer'
local gamestate = require 'gamestate'
local background = require 'background'
local duck = require 'duck'
local Pipe = require 'pipe'

local game = {}

function game:enter ()
  self:start()
end

function game:leave ()
  self:stop()
end

function game:setPaused (paused)
  self.paused = paused
  if BackgroundMusic:isLooping() then
    if self.paused then
      BackgroundMusic:pause()
    else
      BackgroundMusic:play()
    end
  end
end

function game:start ()
  self.score = 0
  self.dead = false
  background:setPaused(false)
  duck:reset()
  self.pipes = {}

  self.pipeSpawn = timer.every(1.2, function ()
    self.pipes[#self.pipes+1] = Pipe()
  end)

  -- duck will glide for a moment so the player can be prepared
  self.glide = true
  timer.after(0.3, function () self.glide = false end)
end

function game:stop ()
  timer.cancel(self.pipeSpawn)
  for _, pipe in pairs(self.pipes) do pipe:cleanup() end
end

function game:hit ()
  self.dead = true
  background:setPaused(true)
  Sounds.hit:play()
  self:stop()

  if self.score > MaxScore then MaxScore = self.score end

  -- ignore keys for a moment to prevent player accidentally restarting the game
  self.allowRestart = false
  timer.after(0.3, function () self.allowRestart = true end)
end

function game:keypressed (key, scancode, isrepeat)
  if key == 'escape' then
    self:setPaused(false)
    self:stop()
    gamestate.pop()
  elseif key == 'p' then
    self:setPaused(not self.paused)
  end

  if not self.paused then
    if not self.dead then
      self.glide = false
      duck:keypressed(key, scancode, isrepeat)
    elseif self.allowRestart and love.keyboard.isActionKey(key) then
      self:start()
    end
  end
end

function game:keyreleased (key)
  if not self.paused then duck:keyreleased(key) end
end

function game:mousepressed (x, y, button)
  local pos = push:toGame(x, y)
  if pos and button == 1 then
    if self.paused then self:setPaused(false) end
    if not self.dead then
      self.glide = false
      duck:mousepressed()
    elseif self.allowRestart then
      self:start()
    end
  end
end

function game:mousereleased (_, _, button)
  if not self.paused and button == 1 then duck:mousereleased() end
end

function game:update (dt)
  if self.paused then return end

  timer.update(dt)

  if not self.dead then
    background:update(dt)
    if not self.glide then duck:update(dt) end
    if duck.y >= HEIGHT-24 then return self:hit() end

    local packedPipes = {}

    for _, pipe in pairs(self.pipes) do
      pipe:update(dt)

      if pipe.x > -70 then
        packedPipes[#packedPipes+1] = pipe
      end

      if pipe.x < WIDTH/8-70 and not pipe.scored then
        self.score = self.score + 1
        pipe.scored = true
        pipe:cleanup()
        Sounds.score:play()
      end
    end

    self.pipes = packedPipes

    for _ in pairs(HC.collisions(duck.polygon)) do
      return self:hit()
    end
  end
end

function game:draw ()
  push:start()
  background:drawBackground()
  for _, pipe in pairs(self.pipes) do pipe:draw() end
  background:drawGround()

  love.graphics.setFont(Fonts.large)
  if self.dead then
    love.graphics.printf('Score: ' .. tostring(self.score), 0, HEIGHT/3, WIDTH, 'center')
    love.graphics.setFont(Fonts.medium)
    love.graphics.printf('Max Score: ' .. tostring(MaxScore), 0, HEIGHT*3/4, WIDTH, 'center')
  else
    love.graphics.printf('Score: ' .. tostring(self.score), 10, 10, WIDTH, 'left')
  end

  duck:draw()

  if self.paused then
    love.graphics.setColor(0, 0, 0, 0.3)
    love.graphics.rectangle('fill', 0, 0, WIDTH, HEIGHT)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(Fonts.large)
    love.graphics.printf('Game Paused', 0, HEIGHT/3, WIDTH, 'center')
  end

  push:finish()
end

function game:focus (focus)
  self:setPaused(not focus)
end

return game

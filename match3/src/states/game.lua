local game = {}

function game:init ()
  self.timer = 0
  self:reset()
end

function game:reset ()
  self.isGameOver = false
  self.timeLeft = 60
  self.score = 0
  self.selected = nil
  self:generate()
end

function game:generate ()
  self.grid = Grid()
  self.grid:generate()
  self.sprites = {}
  for y = 1, ROWS do
    self.sprites[y] = {}
    for x = 1, COLS do
      self.sprites[y][x] = Block(x, y, self.grid.table[y][x])
    end
  end
end

function game:gameOver ()
  self.isGameOver = true
  self.selected = nil
  Sounds.gameOver:play()
end

function game:spriteSwap (x1, y1, x2, y2)
  local t = self.sprites
  local v1, v2 = t[y1][x1], t[y2][x2]
  t[y1][x1] = v2
  t[y2][x2] = v1
end

function game:process (x, y)
  if self._processing then return end
  Convoke(function (continue, wait)
    self._processing = true

    if self.selected then
      local selected = self.selected
      self.selected = nil
      local dx = math.abs(x-selected[1])
      local dy = math.abs(y-selected[2])
      if dx == 0 and dy == 0 then
        self.selected = nil
        self._processing = false
        return
      elseif not (dx == 1 and dy == 1) and (dx == 0 or dx == 1) and (dy == 0 or dy == 1) then
        local s1, s2 = self.sprites[y][x], self.sprites[selected[2]][selected[1]]

        s1:moveTo(unpack(selected))
        s2:moveTo(x, y)
        self:spriteSwap(x, y, unpack(selected))
        Timer.after(0.2, continue()); wait()

        local valid, matches = self.grid:swap(x, y, unpack(selected))
        if valid then
          return self:match(matches)
        else
          Sounds.error:play()
          Timer.after(0.2, continue()); wait()
          s2:moveTo(unpack(selected))
          s1:moveTo(x, y)
          self:spriteSwap(x, y, unpack(selected))
          Timer.after(0.2, continue()); wait()
          self._processing = false
          return
        end
      end
    end

    self.selected = {x, y}
    Sounds.select:play()
    self._processing = false
  end)()
end

function game:match (matches)
  Convoke(function (continue, wait)
    local t = self.grid.table

    self.score = self.score + math.ceil(#matches/3)
    self.timeLeft = self.timeLeft + #matches
    Sounds.match:seek(0)
    Sounds.match:play()

    for _, m in ipairs(matches) do
      local x, y = unpack(m)
      t[y][x] = 0
      self.sprites[y][x]:dissolve()
    end
    Timer.after(0.2, continue()); wait()

    for x = 1, COLS do
      for y = ROWS, 2, -1 do
        if t[y][x] == 0 then
          for i = y-1, 1, -1 do
            if t[i][x] > 0 then
              t[y][x] = t[i][x]
              t[i][x] = 0
              self.sprites[i][x]:moveTo(x, y)
              self:spriteSwap(x, y, x, i)
              break
            end
          end
        end
      end
    end

    self.grid:fill()
    for y = 1, ROWS do
      for x = 1, COLS do
        if self.sprites[y][x].destroyed or self.sprites[y][x].dissolving then
          self.sprites[y][x] = Block(x, y, self.grid.table[y][x], false)
        end
      end
    end
    Timer.after(0.2, continue()); wait()

    for y = 1, ROWS do
      for x = 1, COLS do
        if not self.sprites[y][x].visible then
          self.sprites[y][x]:appear()
        end
      end
    end
    Timer.after(0.2, continue()); wait()

    local nm = self.grid:matches()
    if #nm > 0 then
      game:match(nm)
    elseif not self.grid:validate() then
      for y = 1, ROWS do
        for x = 1, COLS do
          self.sprites[y][x]:dissolve()
        end
      end
      Timer.after(0.2, continue()); wait()
      self:generate()
      self._processing = false
    else
      self._processing = false
    end
  end)()
end

function game:setPaused (paused)
  self.paused = paused
  if paused then
    Sounds.music:pause()
  else
    Sounds.music:play()
  end
end

function game:update (dt)
  if self.paused then return end
  self.timer = self.timer+dt
  if self.timer >= 1 then
    if not self.isGameOver then
      self.timeLeft = self.timeLeft - 1
      if self.timeLeft == 0 then self:gameOver()
      elseif self.timeLeft <= 10 then Sounds.clock:play()
      end
    end
    self.timer = 0
  end

  local sprites = {}
  for y = 1, ROWS do
    sprites[y] = {}
    for x = 1, COLS do
      local sprite = self.sprites[y][x]
      if sprite and not sprite.destroyed then sprites[y][x] = sprite end
    end
  end
  self.sprites = sprites
end

function game:render ()
  if self.paused then
    Printf('Game Paused', Fonts.medium, {1,1,1}, 0, VIRTUAL_HEIGHT/2-16, VIRTUAL_WIDTH, 'center')
    return
  end

  love.graphics.setColor(0.9,0.9,0.9,0.8)
  love.graphics.rectangle('fill', 210, 8, 272, 272, 6, 6)
  love.graphics.rectangle('fill', 30, 8, 150, 162, 6, 6)
  love.graphics.setColor(0.9,0.9,0.9,0.9)
  love.graphics.rectangle('fill', 46, 24, 118, 130, 6, 6)

  Printf('Time Left', Fonts.small, {0.3,0.3,0.3}, 30, 40, 150, 'center')
  Printf(tostring(self.timeLeft), Fonts.small, {0.4,0.4,0.4}, 30, 60, 150, 'center')
  Printf('Score', Fonts.small, {0.3,0.3,0.3}, 30, 100, 150, 'center')
  Printf(tostring(self.score), Fonts.small, {0.4,0.4,0.4}, 30, 120, 150, 'center')

  if self.isGameOver and self.timer > 0.3 then
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle('fill', 30, 200, 150, 30, 6, 6)
    Printf('Play again', Fonts.small, {0.3,0.3,0.3}, 30, 208, 150, 'center')
  end

  love.graphics.setColor(1,1,1,1)
  local t = self.sprites
  for y = 1, ROWS do
    for x = 1, COLS do
      local s = t[y][x]
      if s then s:render() end
    end
  end

  if self.selected then
    love.graphics.setColor(1,1,1,0.5)
    love.graphics.rectangle('fill', 214+33*(self.selected[1]-1), 12+33*(self.selected[2]-1), 32, 32, 6, 6)
    love.graphics.setColor(1,0,0,0.7)
    love.graphics.rectangle('line', 214+33*(self.selected[1]-1), 12+33*(self.selected[2]-1), 32, 32, 6, 6)
  end
end

function game:mousepressed (x, y, button)
  x, y = Push:toGame(x, y)
  if button == 1 then
    if self.isGameOver and x >= 30 and x <= 180 and y >= 200 and y <= 230 then return self:reset() end
    if self.isGameOver then return end
    if x >= 214 and x <= 478 and y >= 12 and y <= 276 then
      self:process(math.floor((x-214)/33+1), math.floor((y-12)/33+1))
    end
  end
end

function game:focus (focus)
  self:setPaused(not focus)
end

return game

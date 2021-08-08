local mainMenu = {}

function mainMenu:init ()
  self.idx = 0
end

function mainMenu:update (dt)
  if Input:pressed('action') then
    if self.idx == 0 then
      Gamestate.push(States.game)
    elseif self.idx == 1 then
      Gamestate.push(States.highScores)
    elseif self.idx == 2 then
      love.event.quit()
    end
  elseif Input:pressed('back') then
    love.event.quit()
  elseif Input:pressed('down') then
    self.idx = self.idx + 1
    Sounds.select:play()
  elseif Input:pressed('up') then
    self.idx = self.idx - 1
    Sounds.select:play()
  end
  if self.idx < 0 then
    self.idx = 2
  elseif self.idx > 2 then
    self.idx = 0
  end
end

function mainMenu:render ()
  love.graphics.clear(unpack(BackgroundColors.C))

  love.graphics.setFont(Fonts.large)
  love.graphics.printf('Bricks', 0, 50, VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(Fonts.small)
  love.graphics.printf('by', 0, 170, VIRTUAL_WIDTH, 'center')
  love.graphics.printf('Iury Ramos Garcia', 0, 210, VIRTUAL_WIDTH, 'center')

  local setColorIdx = function (idx) love.graphics.setColor(unpack(idx == self.idx and {0,1,0} or {1,1,1})) end
  love.graphics.setFont(Fonts.medium)
  setColorIdx(0)
  love.graphics.printf('New Game', 0, 450, VIRTUAL_WIDTH, 'center')
  setColorIdx(1)
  love.graphics.printf('High Scores', 0, 510, VIRTUAL_WIDTH, 'center')
  setColorIdx(2)
  love.graphics.printf('Quit Game', 0, 570, VIRTUAL_WIDTH, 'center')
  setColorIdx(-1)
end

return mainMenu

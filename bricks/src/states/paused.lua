local paused = {}

function paused:update ()
  if Input:pressed('unpause') then
    Gamestate.pop()
  end
end

function paused:render ()
  love.graphics.draw(Graphics.edgeTop, 0, 70)
  love.graphics.draw(Graphics.edgeLeft, 0, 70)
  love.graphics.draw(Graphics.edgeRight, VIRTUAL_WIDTH-22, 70)
  love.graphics.setFont(Fonts.medium)
  love.graphics.printf('Game Paused', 0, 360, VIRTUAL_WIDTH, 'center')
end

return paused

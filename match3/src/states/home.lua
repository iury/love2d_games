local home = {}

local timer = 0
local color1 = 1
local color2 = 1
local color3 = 1

function home:update (dt)
  timer = timer + dt
  if timer > 0.3 then
    color1 = math.random()
    color2 = math.random()
    color3 = math.random()
    timer = 0
  end
end

function home:keypressed (key)
  if key == 'escape' then
    love.event.quit()
  end
end

function home:render ()
  Printf('Match 3', Fonts.large, {color1,color2,color3}, 0, 60, VIRTUAL_WIDTH, 'center', true)
  Printf('by', Fonts.small, {1,1,1}, 0, 120, VIRTUAL_WIDTH, 'center', true)
  Printf('Iury Ramos Garcia', Fonts.small, {1,1,1}, 0, 140, VIRTUAL_WIDTH, 'center', true)
  Printf('Click to Start', Fonts.small, { 0.5+color1*0.5, 0.5+color1*0.5, 0.5+color1*0.5 }, 0, VIRTUAL_HEIGHT-70, VIRTUAL_WIDTH, 'center', true)
  Printf('v1.1 (2021)', Fonts.small, {1,1,1}, 20, VIRTUAL_HEIGHT-28, VIRTUAL_WIDTH, 'left', true)
end

function home:mousepressed (_, _, button)
  if button == 1 then Gamestate.switch(States.game) end
end

return home

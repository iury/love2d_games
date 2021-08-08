if os.getenv('LOCAL_LUA_DEBUGGER_VSCODE') == '1' then
  require('lldebugger').start()
end

require 'src/global'

local backgroundX = 0

function love.load ()
  math.randomseed(os.time())
  love.graphics.setDefaultFilter('nearest', 'nearest')
  Push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, { resizable = true })
  Gamestate.registerEvents()
  Gamestate.switch(States.home)
  Sounds.music:setLooping(true)
  Sounds.music:play()
end

function love.resize (w, h)
  Push:resize(w,h)
end

function love.update (dt)
  backgroundX = backgroundX - 40*dt
  if backgroundX <= -977 + VIRTUAL_WIDTH then backgroundX = 0 end
  Timer.update(dt)
end

function love.draw ()
  love.window.setTitle(string.gsub(love.window.getTitle(), ' %- .+', '') .. ' - FPS: ' .. love.timer.getFPS())
  Push:start()
  love.graphics.draw(Graphics.background, backgroundX, 0)
  Gamestate.current():render()
  Push:finish()
end

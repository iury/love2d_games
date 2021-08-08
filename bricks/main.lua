if os.getenv('LOCAL_LUA_DEBUGGER_VSCODE') == '1' then
  require('lldebugger').start()
end

require 'src/global'

local push = require 'libs/push'

function love.load ()
  love.mouse.setVisible(false)
  love.graphics.setDefaultFilter('nearest', 'nearest')
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, { resizable = true })
  Gamestate.registerEvents()
  Gamestate.switch(States.mainMenu)
end

function love.resize (w, h)
  push:resize(w,h)
end

function love.update (dt)
  Input:update()
  Timer.update(dt)
end

function love.draw ()
  love.window.setTitle(string.gsub(love.window.getTitle(), ' - .+', '') .. ' - FPS: ' .. love.timer.getFPS())
  push:start()
  Gamestate.current():render()
  push:finish()
end

function love.joystickadded (joystick)
  Input.config.joystick = joystick
end

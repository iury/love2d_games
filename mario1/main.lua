if os.getenv('LOCAL_LUA_DEBUGGER_VSCODE') == '1' then
  require('lldebugger').start()
end

require 'src/global'

local push = require 'libs/push'
local level, t = nil, 0

function love.load ()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, { resizable = true })
  level = Levels.level1()

  Event.on('dead', function ()
    Sounds.mainTheme:stop()
    Sounds.death:play()
    Timer.after(3, function ()
      if level then level:destroy() end
      level = Levels.level1()
    end)
  end)

  Event.on('pipedown', function ()
    Sounds.mainTheme:stop()
    Sounds.pipe:play()
    Timer.after(1, function ()
      level:destroy()
      level = Levels.level1u()
    end)
  end)

  Event.on('pipeexit', function ()
    Sounds.underworld:stop()
    Sounds.pipe:play()
    Timer.after(1, function ()
      level:destroy()
      level = Levels.level1(true)
      GlobalState.tx = -level.pipeup[1]
    end)
  end)

  Event.on('stageClear', function ()
    Timer.after(3, function ()
      if level then level:destroy() end
      level = Levels.level1()
    end)
  end)
end

function love.resize (w, h)
  push:resize(w,h)
end

function love.update (dt)
  Timer.update(dt)
  t = t + dt
  if not GlobalState.frozeSprites and t >= 1/60 then
    Input:update()
    GlobalState.onFrame = true
    t = t % 1/60
  else
    GlobalState.onFrame = false
  end
  level:update(dt)
end

function love.draw ()
  love.window.setTitle(string.gsub(love.window.getTitle(), ' %- .+', '') .. ' - FPS: ' .. love.timer.getFPS())
  push:start()
  level:render()
  push:finish()
end

function love.joystickadded (joystick)
  Input.config.joystick = joystick
end

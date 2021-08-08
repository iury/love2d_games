return Baton.new {
  controls = {
    left = {'key:left', 'sc:a', 'axis:leftx-', 'button:dpleft'},
    right = {'key:right', 'sc:d', 'axis:leftx+', 'button:dpright'},
    up = {'key:up', 'sc:w', 'axis:lefty-', 'button:dpup'},
    down = {'key:down', 'sc:s', 'axis:lefty+', 'button:dpdown'},
    back = {'key:escape', 'key:backspace', 'button:back', 'button:b'},
    action = {'key:return', 'key:kpenter', 'key:space', 'button:start', 'button:a', 'button:x'},
    pause = {'key:escape', 'key:p', 'button:guide', 'button:start'},
    unpause = {
      'key:p', 'key:return', 'key:kpenter', 'key:space', 'key:escape',
      'button:guide', 'button:start', 'button:back',
      'button:b', 'button:a', 'button:x'
    },
  },
  pairs = {
    move = {'left', 'right', 'up', 'down'},
  },
  joystick = love.joystick.getJoysticks()[1],
}

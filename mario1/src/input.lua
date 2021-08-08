return Baton.new {
  controls = {
    left  = {'key:left', 'sc:a', 'axis:leftx-', 'button:dpleft'},
    right = {'key:right', 'sc:d', 'axis:leftx+', 'button:dpright'},
    up    = {'key:up', 'sc:w', 'axis:lefty-', 'button:dpup'},
    down  = {'key:down', 'sc:s', 'axis:lefty+', 'button:dpdown'},
    b     = {'key:rshift', 'key:lshift', 'button:x'},
    a     = {'key:rctrl', 'key:lctrl', 'key:space', 'button:a'},
  },
  pairs = {
    move = {'left', 'right', 'up', 'down'},
  },
  joystick = love.joystick.getJoysticks()[1],
}

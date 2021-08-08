VIRTUAL_WIDTH = 556
VIRTUAL_HEIGHT = 720
WINDOW_WIDTH = 556
WINDOW_HEIGHT = 720

require 'src/assets'

Baton = require 'libs/baton'
Bump = require 'libs/bump'
Class = require 'libs/class'
Gamestate = require 'libs/gamestate'
Json = require 'libs/json'
Timer = require 'libs/timer'
Signal = require 'libs/signal'

Level = require 'src/level'
Input = require 'src/input'

Paddle = require 'src/sprites/paddle'
Ball = require 'src/sprites/ball'
Brick = require 'src/sprites/brick'
Powerup = require 'src/sprites/powerup'
Fire = require 'src/sprites/fire'
Lives = require 'src/sprites/lives'
Edge = require 'src/sprites/edge'
Deadzone = require 'src/sprites/deadzone'

States = {
  mainMenu = require 'src/states/mainMenu',
  game = require 'src/states/game',
  paused = require 'src/states/paused',
  highScores = require 'src/states/highScores',
}

World = Bump.newWorld(64)

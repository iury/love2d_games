VIRTUAL_WIDTH = 256
VIRTUAL_HEIGHT = 240
WINDOW_WIDTH = 512
WINDOW_HEIGHT = 480

require 'src/assets'

Baton = require 'libs/baton'
Bump = require 'libs/bump'
Base = require 'libs/knife.base'
Behavior = require 'libs/knife.behavior'
Timer = require 'libs/knife.timer'
Event = require 'libs/knife.event'

Input = require 'src/input'
BaseSprite = require 'src/sprites/base'
BaseLevel = require 'src/levels/base'

Levels = {
  level1 = require 'src/levels/level1',
  level1u = require 'src/levels/level1u',
}

GlobalState = {
  tx = 0,
  txlimit = 0,
  onFrame = false,
  world = nil,
  facingDirection = 1,
  marioStanding = true,
  frozeSprites = false,
}

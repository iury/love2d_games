VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

ROWS = 8
COLS = 8

require 'src/util'
require 'src/assets'

Push = require 'libs/push'
Gamestate = require 'libs/gamestate'
Base = require 'libs/knife.base'
Timer = require 'libs/knife.timer'
Convoke = require 'libs/knife.convoke'

Grid = require 'src/grid'
Block = require 'src/sprites/block'

States = {
  home = require 'src/states/home',
  game = require 'src/states/game',
}

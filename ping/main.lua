Gamestate = require 'gamestate'
Push = require 'push'

Menu = require 'menu'
Game = require 'game'

WIDTH = 320
HEIGHT = 240

Fonts = {
  small = love.graphics.newFont('assets/font.ttf', 8),
  medium = love.graphics.newFont('assets/font.ttf', 16),
  large = love.graphics.newFont('assets/font.ttf', 32),
}

Sounds = {
  paddleHit = love.audio.newSource('assets/paddle_hit.wav', 'static'),
  wallHit = love.audio.newSource('assets/wall_hit.wav', 'static'),
  score = love.audio.newSource('assets/score.wav', 'static'),
}

function love.load ()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  Push:setupScreen(WIDTH, HEIGHT, 640, 480, { resizable = true })
  Gamestate.registerEvents()
  Gamestate.switch(Menu)
end

function love.resize (w, h)
  Push:resize(w, h)
end

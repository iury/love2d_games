PIPE_SPEED = 240
WIDTH = 512
HEIGHT = 288

MaxScore = 0

local json = require 'json'
local push = require 'push'
local gamestate = require 'gamestate'
local menu = require 'menu'

Fonts = {
  small = love.graphics.newFont('assets/font.ttf', 8),
  medium = love.graphics.newFont('assets/font.ttf', 16),
  large = love.graphics.newFont('assets/flappy.ttf', 32),
}

Sounds = {
  cursor = love.audio.newSource('assets/cursor.wav', 'static'),
  score = love.audio.newSource('assets/score.wav', 'static'),
  wing = love.audio.newSource('assets/wing.mp3', 'static'),
  hit = love.audio.newSource('assets/hit.mp3', 'static'),
}

function love.keyboard.isActionKey (key)
  return key == 'w' or key == 'up' or key == 'space' or key == 'kpenter' or key == 'return'
end

function love.load ()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  push:setupScreen(WIDTH, HEIGHT, 1280, 720, { resizable = true })
  gamestate.registerEvents()

  BackgroundMusic = love.audio.newSource('assets/background.mp3', 'stream')
  BackgroundMusic:setLooping(true)
  BackgroundMusic:play()

  if love.filesystem.getInfo('data.duck') then
    local data = json.decode(love.filesystem.read('data.duck'))
    MaxScore = data.maxScore
    if not data.bgm then
      BackgroundMusic:setLooping(false)
      BackgroundMusic:stop()
    end
    if not data.sfx then
      love.audio.setVolume(0)
    end
    if data.fullscreen then
      push:switchFullscreen(1280, 720)
    end
  end

  gamestate.switch(menu)
end

function love.quit ()
  local data = {
    maxScore = MaxScore,
    fullscreen = (love.window.getFullscreen())
  }

  if BackgroundMusic:isPlaying() then
    data.bgm = true
    data.sfx = true
  elseif love.audio.getVolume() == 1 then
    data.bgm = false
    data.sfx = true
  else
    data.bgm = false
    data.sfx = false
  end

  love.filesystem.write('data.duck', json.encode(data))
end

function love.resize (w, h)
  push:resize(w, h)
end

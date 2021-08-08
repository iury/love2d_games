Fonts = {
  small  = love.graphics.newFont('assets/fonts/font.ttf', 16),
  medium = love.graphics.newFont('assets/fonts/font.ttf', 24),
  large  = love.graphics.newFont('assets/fonts/font.ttf', 48),
}

Sounds = {
  music     = love.audio.newSource('assets/sounds/music.mp3', 'stream'),
  clock     = love.audio.newSource('assets/sounds/clock.mp3', 'static'),
  error     = love.audio.newSource('assets/sounds/error.mp3', 'static'),
  match     = love.audio.newSource('assets/sounds/match.mp3', 'static'),
  select    = love.audio.newSource('assets/sounds/select.mp3', 'static'),
  gameOver  = love.audio.newSource('assets/sounds/game_over.mp3', 'static'),
}

Graphics = {
  background = love.graphics.newImage('assets/graphics/background.png'),
  tiles      = love.graphics.newImage('assets/graphics/match3.png'),
}

Quads = {
  love.graphics.newQuad(32*0,0,32,32,Graphics.tiles:getDimensions()),
  love.graphics.newQuad(32*1,0,32,32,Graphics.tiles:getDimensions()),
  love.graphics.newQuad(32*2,0,32,32,Graphics.tiles:getDimensions()),
  love.graphics.newQuad(32*3,0,32,32,Graphics.tiles:getDimensions()),
  love.graphics.newQuad(32*4,0,32,32,Graphics.tiles:getDimensions()),
  love.graphics.newQuad(32*5,0,32,32,Graphics.tiles:getDimensions()),
}

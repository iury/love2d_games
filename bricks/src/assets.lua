Fonts = {
  small = love.graphics.newFont('assets/fonts/emulogic.ttf', 16),
  medium = love.graphics.newFont('assets/fonts/emulogic.ttf', 24),
  large = love.graphics.newFont('assets/fonts/emulogic.ttf', 64),
  score = love.graphics.newFont('assets/fonts/generation.ttf', 24),
}

Sounds = {
  gameEnd = love.audio.newSource('assets/sounds/game_end.mp3', 'stream'),
  start   = love.audio.newSource('assets/sounds/start.mp3', 'static'),
  select  = love.audio.newSource('assets/sounds/select.mp3', 'static'),
  up      = love.audio.newSource('assets/sounds/up.mp3', 'static'),
  down    = love.audio.newSource('assets/sounds/down.mp3', 'static'),
  bounce  = love.audio.newSource('assets/sounds/bounce.mp3', 'static'),
  dead    = love.audio.newSource('assets/sounds/dead.mp3', 'static'),
  fire    = love.audio.newSource('assets/sounds/fire.mp3', 'static'),
  life    = love.audio.newSource('assets/sounds/life.mp3', 'static'),
  catch   = love.audio.newSource('assets/sounds/catch.mp3', 'static'),
  powerup = love.audio.newSource('assets/sounds/powerup.mp3', 'static'),
}

Graphics = {
  ball         = love.graphics.newImage('assets/graphics/ball.png'),
  paddle       = love.graphics.newImage('assets/graphics/paddle.png'),
  paddleWide   = love.graphics.newImage('assets/graphics/paddle_wide.png'),
  paddleLaser  = love.graphics.newImage('assets/graphics/paddle_laser.png'),
  pulsate      = love.graphics.newImage('assets/graphics/pulsate.png'),
  pulsateWide  = love.graphics.newImage('assets/graphics/pulsate_wide.png'),
  pulsateLaser = love.graphics.newImage('assets/graphics/pulsate_laser.png'),
  bricks       = love.graphics.newImage('assets/graphics/bricks.png'),
  brickSilver  = love.graphics.newImage('assets/graphics/brick_silver.png'),
  edgeLeft     = love.graphics.newImage('assets/graphics/edge_left.png'),
  edgeRight    = love.graphics.newImage('assets/graphics/edge_right.png'),
  edgeTop      = love.graphics.newImage('assets/graphics/edge_top.png'),
  enlarge      = love.graphics.newImage('assets/graphics/enlarge.png'),
  explode      = love.graphics.newImage('assets/graphics/explode.png'),
  laser        = love.graphics.newImage('assets/graphics/laser.png'),
  life         = love.graphics.newImage('assets/graphics/life.png'),
  materialize  = love.graphics.newImage('assets/graphics/materialize.png'),
  bullet       = love.graphics.newImage('assets/graphics/bullet.png'),
  powerup      = love.graphics.newImage('assets/graphics/powerup.png'),
}

BackgroundColors = {
  C = {0.05, 0.05, 0.05},
  B = {1/255, 0, 122/255},
  G = {9/255, 150/255, 2/255},
  R = {116/255, 0, 1/255},
  D = {1/255, 0, 122/255},
}

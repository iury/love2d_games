Sounds = {
  mainTheme      = love.audio.newSource('assets/sounds/main_theme.ogg', 'stream'),
  underworld     = love.audio.newSource('assets/sounds/underworld.ogg', 'stream'),
  stageClear     = love.audio.newSource('assets/sounds/stage_clear.wav', 'stream'),
  bigJump        = love.audio.newSource('assets/sounds/big_jump.ogg', 'static'),
  brickSmash     = love.audio.newSource('assets/sounds/brick_smash.ogg', 'static'),
  bump           = love.audio.newSource('assets/sounds/bump.ogg', 'static'),
  coin           = love.audio.newSource('assets/sounds/coin.ogg', 'static'),
  death          = love.audio.newSource('assets/sounds/death.wav', 'static'),
  flagpole       = love.audio.newSource('assets/sounds/flagpole.wav', 'static'),
  invincible     = love.audio.newSource('assets/sounds/invincible.ogg', 'static'),
  kick           = love.audio.newSource('assets/sounds/kick.ogg', 'static'),
  powerup        = love.audio.newSource('assets/sounds/powerup.ogg', 'static'),
  powerupAppears = love.audio.newSource('assets/sounds/powerup_appears.ogg', 'static'),
  smallJump      = love.audio.newSource('assets/sounds/small_jump.ogg', 'static'),
  stomp          = love.audio.newSource('assets/sounds/stomp.ogg', 'static'),
  pipe           = love.audio.newSource('assets/sounds/pipe.ogg', 'static'),
  up             = love.audio.newSource('assets/sounds/up.ogg', 'static'),
}

Graphics = {
  sprites = love.graphics.newImage('assets/graphics/sprites.png'),
  tiles   = love.graphics.newImage('assets/graphics/tiles.png'),
}

Quads = {
  sprites = {},
  tiles = {},
}

Sounds.mainTheme:setLooping(true)
Sounds.underworld:setLooping(true)

for y = 1, 16 do
  Quads.sprites[y] = {}
  for x = 1, 16 do
    Quads.sprites[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, Graphics.sprites:getDimensions())
  end
end

for y = 1, 14 do
  Quads.tiles[y] = {}
  for x = 1, 16 do
    Quads.tiles[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, Graphics.tiles:getDimensions())
  end
end

Gamestate = require 'gamestate'
Push = require 'push'
Player = require 'player'
Ball = require 'ball'

POINTS_TO_WIN = 10

local game = {}

function game:reset ()
  self.hasFocus = love.window.hasFocus()
  self.player1Score = 0
  self.player2Score = 0
  self.state = 'serve'
  self.servePlayer = 1
  self.player1 = Player(10, 30, 'w', 's')
  self.player2 = Player(WIDTH-12, HEIGHT-54, 'up', 'down')
  self.ball = Ball()
end

function game:keypressed (key)
  if key == 'escape' then
    Gamestate.switch(Menu)
  elseif key == 'enter' or key == 'return' then
    if self.state == 'serve' then
      Sounds.paddleHit:play()
      self.state = 'play'
    elseif self.state == 'end' then
      self:reset()
    end
  end
end

function game:update (dt)
  if not self.hasFocus then return end

  if self.state ~= 'end' then
    self.player1:update(dt)
    self.player2:update(dt)
  end

  if self.state == 'play' then
    self.ball:update(dt)

    if self.ball.direction == 1 then
      if self.ball.x >= WIDTH-4 then
        Sounds.score:play()
        self.player1Score = self.player1Score + 1
        self.servePlayer = 1
        self.state = 'serve'

      elseif self.ball:collides(self.player2) then
        Sounds.paddleHit:play()
        self.ball:revert()
      end

    else
      if self.ball.x <= 0 then
        Sounds.score:play()
        self.player2Score = self.player2Score + 1
        self.servePlayer = 2
        self.state = 'serve'

      elseif self.ball:collides(self.player1) then
        Sounds.paddleHit:play()
        self.ball:revert()
      end
    end

    if self.player1Score == POINTS_TO_WIN or self.player2Score == POINTS_TO_WIN then
      self.state = 'end'
    end

  elseif self.state == 'serve' then
    if self.servePlayer == 1 then
      self.ball:reset(self.player1.x + 12, self.player1.y + 10, 1)
    else
      self.ball:reset(self.player2.x - 12, self.player2.y + 10, -1)
    end
  end
end

function game:draw ()
  Push:start()

  love.graphics.setFont(Fonts.large)
  love.graphics.printf(tostring(self.player1Score), 0, 10, WIDTH/2-12, 'right')
  love.graphics.printf(tostring(self.player2Score), WIDTH/2+16, 10, WIDTH/2, 'left')

  if self.state ~= 'end' then
    self.ball:draw()
    for x = 1, HEIGHT/16-1 do
      love.graphics.rectangle('fill', WIDTH/2-1, x*16-4, 2, 8)
    end
  end

  if self.state == 'serve' then
    love.graphics.setFont(Fonts.small)
    love.graphics.printf('Press ENTER', 0, HEIGHT-44, WIDTH, 'center')

    if self.player1Score == 0 and self.player2Score == 0 then
      love.graphics.printf('W = Up\nS = Down', 30, HEIGHT/2, WIDTH, 'left')
      love.graphics.printf('Arrow keys\nUp and Down', 0, HEIGHT/2, WIDTH-30, 'right')
    end

  elseif self.state == 'end' then
    love.graphics.setFont(Fonts.medium)
    love.graphics.printf('Player ' .. (self.player1Score > self.player2Score and '1' or '2') .. ' won!', 0, HEIGHT/2, WIDTH, 'center')
  end

  self.player1:draw()
  self.player2:draw()

  Push:finish()
end

function game:focus (focus)
  self.hasFocus = focus
end

return game

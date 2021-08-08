local mario = BaseSprite:extend({ type = 'mario' })

function mario:constructor (x, y)
  self.destroyed = false
  self.visible = true
  self.collisionable = true
  self.controllable = true
  self.big = false

  self.x = x
  self.y = y
  self.dx = 0
  self.dy = 0
  self.direction = 1
  self.velocity = 0
  self.acceleration = 0
  self.maxspeed = 0
  self.jumpspeed = 0
  self.holdspeed = 0
  self.gravity = 0x200

  self.behavior = Behavior {
    default = {
      { duration = 0, after = 'smallIdle' },
    },
    smallIdle = {
      { duration = 1, quad = Quads.sprites[7][1] },
    },
    smallWalk = {
      { duration = 0.1, quad = Quads.sprites[7][2] },
      { duration = 0.1, quad = Quads.sprites[7][4] },
      { duration = 0.1, quad = Quads.sprites[7][3] },
    },
    smallJump = {
      { duration = 1, quad = Quads.sprites[7][6] },
    },
    smallTurn = {
      { duration = 1, quad = Quads.sprites[7][5] },
    },
    smallSlide = {
      { duration = 0.3, quad = Quads.sprites[8][1], action = function() Sounds.mainTheme:stop(); Sounds.flagpole:play() end },
      { duration = 1.0, quad = Quads.sprites[8][1], action = function() self.gravity = 0x200 end },
      { duration = 0.5, quad = Quads.sprites[8][2], action = function() Sounds.stageClear:play() end },
      { duration = 0.5, quad = Quads.sprites[8][2], action = function() self.x = self.x+8; GlobalState.facingDirection = -1 end },
      {
        duration = 0,
        after = 'smallWalk',
        action = function()
          self.x = self.x+8
          self.direction = 1
          self.acceleration = 0x98
          GlobalState.facingDirection = 1
          Timer.after(3, function()
            Event.dispatch('stageClear')
          end)
        end
      },
    },
    bigIdle = {
      { duration = 1, quad = Quads.sprites[8][8], head = Quads.sprites[7][8] },
    },
    bigWalk = {
      { duration = 0.1, quad = Quads.sprites[8][10], head = Quads.sprites[7][10] },
      { duration = 0.1, quad = Quads.sprites[8][11], head = Quads.sprites[7][11] },
      { duration = 0.1, quad = Quads.sprites[8][9], head = Quads.sprites[7][9] },
    },
    bigJump = {
      { duration = 1, quad = Quads.sprites[10][13], head = Quads.sprites[9][13] },
    },
    bigTurn = {
      { duration = 1, quad = Quads.sprites[8][12], head = Quads.sprites[7][12] },
    },
    bigSlide = {
      { duration = 0.3, quad = Quads.sprites[10][3], head = Quads.sprites[9][3], action = function() Sounds.mainTheme:stop(); Sounds.flagpole:play() end },
      { duration = 1.0, quad = Quads.sprites[10][3], head = Quads.sprites[9][3], action = function() self.gravity = 0x200 end },
      { duration = 0.5, quad = Quads.sprites[10][2], head = Quads.sprites[9][2], action = function() Sounds.stageClear:play() end },
      { duration = 0.5, quad = Quads.sprites[10][2], head = Quads.sprites[9][2], action = function() self.x = self.x+8; GlobalState.facingDirection = -1 end },
      {
        duration = 0,
        after = 'bigWalk',
        action = function()
          self.x = self.x+8
          self.direction = 1
          self.acceleration = 0x98
          GlobalState.facingDirection = 1
          Timer.after(3, function()
            Event.dispatch('stageClear')
          end)
        end
      },
    },
    bigDuck = {
      { duration = 1, quad = Quads.sprites[10][1], head = Quads.sprites[9][1] },
    },
    grow = {
      { duration = 0.1, quad = Quads.sprites[10][10], head = Quads.sprites[9][10] },
      { duration = 0.1, quad = Quads.sprites[8][8], head = Quads.sprites[7][8] },
      { duration = 0.1, quad = Quads.sprites[10][10], head = Quads.sprites[9][10] },
      { duration = 0.1, quad = Quads.sprites[8][8], head = Quads.sprites[7][8] },
      { duration = 0.1, quad = Quads.sprites[10][10], head = Quads.sprites[9][10] },
      {
        duration = 0.1,
        quad = Quads.sprites[8][8],
        head = Quads.sprites[7][8],
        after = 'bigIdle',
        action = function() self:grow() end
      },
    },
    shrink = {
      { duration = 0.1, quad = Quads.sprites[10][10], head = Quads.sprites[9][10] },
      { duration = 0.1, quad = Quads.sprites[7][1] },
      { duration = 0.1, quad = Quads.sprites[10][10], head = Quads.sprites[9][10] },
      { duration = 0.1, quad = Quads.sprites[7][1] },
      { duration = 0.1, quad = Quads.sprites[10][10], head = Quads.sprites[9][10] },
      {
        duration = 0.1,
        quad = Quads.sprites[7][1],
        after = 'smallIdle',
        action = function() self:shrink() end
      },
    },
    dead = {
      { duration = 1, quad = Quads.sprites[7][7] },
      {
        duration = 3,
        quad = Quads.sprites[7][7],
        action = function ()
          self.jumpspeed = -0x5000
          self.holdspeed = 0x280
          self.gravity = 0x900
        end
      }
    },
  }

  GlobalState.world:add(self, self.x+1, self.y, 14, 16)
end

function mario:grow ()
  self.big = true
  GlobalState.world:update(self, self.x, self.y-16, 16, 32)
  self.y = self.y-16
  GlobalState.frozeSprites = false
  self:setControllable(true)
end

function mario:shrink ()
  self.big = false
  GlobalState.frozeSprites = false
  self:setControllable(true)
end

function mario:hit (sprite, col)
  if sprite.hit then sprite:hit(col, self.big) end
  if GlobalState.marioStanding then
    if sprite.enemy then
      if self.big then
        self.big = false
        Sounds.pipe:play()
        self:setControllable(false)
        self.behavior:setState('shrink')
        self.invincible = true
        Timer.after(0.5, function() self.invincible = false end)
      elseif not self.invincible then
        self.collisionable = false
        self:setControllable(false)
        self.velocity = 0
        self.acceleration = 0
        self.jumpspeed = 0
        self.holdspeed = 0
        self.gravity = 0
        self.behavior:setState('dead')
        Event.dispatch('dead')
      end
    elseif col then
      sprite:stomp(col.touch)
    end
  elseif col then
    sprite:stomp(col.touch)
    self.jumpspeed = -0x4000
  end
end

function mario:setControllable(controllable)
  self.controllable = controllable
  GlobalState.world:update(self, controllable and self.x+1 or self.x, self.y, controllable and 14 or 16, self.big and 32 or 16)
end

function mario:update (dt)
  self.behavior:update(dt)
  if GlobalState.onFrame then
    local run = self.controllable and Input:down('b')
    local jump = self.controllable and Input:down('a')

    local h = Input:down('right') and 1 or (Input:down('left') and -1 or 0)
    local v = Input:down('down') and 1 or (Input:down('up') and -1 or 0)
    if not self.controllable then h = 0; v = 0 end

    if h ~= 0 and GlobalState.marioStanding then GlobalState.facingDirection = h end

    self.velocity = self.velocity+self.acceleration
    if self.velocity > self.maxspeed then self.velocity = self.maxspeed end
    if self.velocity <= 0 then
      self.velocity = 0
      self.acceleration = 0
      self.direction = math.abs(h) ~= 0 and h or GlobalState.facingDirection
    end

    self.dx = self.velocity / 0x1000 * self.direction
    self.dy = self.jumpspeed / 0x1000

    local cols, len
    if self.collisionable then
      local actualX, actualY
      actualX, actualY, cols, len = GlobalState.world:move(self, math.max(-GlobalState.tx, self.x+self.dx), self.y+self.dy, function (_, other)
        if other.collision == false then return nil end
        return other.collision or 'slide'
      end)
      self.x = actualX
      self.y = actualY
    else
      self.x = self.x+self.dx
      self.y = self.y+self.dy
      cols, len = nil, 0
    end

    self.jumpspeed = self.jumpspeed + ((jump and self.jumpspeed < 0 and self.holdspeed) or self.gravity)
    if self.jumpspeed > 0x4000 then self.jumpspeed = 0x4000 end

    if self.controllable then
      if h == self.direction then
        self.velocity = math.max(self.velocity, 0x130)
        if GlobalState.marioStanding then
          self.acceleration = run and 0xe4 or 0x98
          self.maxspeed = run and 0x2900 or 0x1900
        else
          self.acceleration = self.velocity >= 0x1900 and 0xe4 or 0x98
        end
      elseif self.velocity > 0 then
        if GlobalState.marioStanding then
          self.acceleration = h == 0 and -0xd0 or -0x1a0
        else
          self.acceleration = self.velocity >= 0x1900 and -0xe4 or -0xd0
        end
      end
    end

    if GlobalState.marioStanding and self.controllable and Input:pressed('a') then
      if self.velocity < 0x1000 then
        self.jumpspeed = -0x4000
        self.holdspeed = 0x200
        self.gravity = 0x700
      elseif self.velocity < 0x24ff then
        self.jumpspeed = -0x4000
        self.holdspeed = 0x1e0
        self.gravity = 0x600
      else
        self.jumpspeed = -0x5000
        self.holdspeed = 0x280
        self.gravity = 0x900
      end
    end

    if self.controllable then
      if GlobalState.marioStanding then
        if self.direction ~= GlobalState.facingDirection then
          if self.behavior.state ~= 'bigTurn' and self.behavior.state ~= 'smallTurn' then self.behavior:setState(self.big and 'bigTurn' or 'smallTurn') end
        elseif self.velocity > 0 then
          if self.behavior.state ~= 'bigWalk' and self.behavior.state ~= 'smallWalk' then self.behavior:setState(self.big and 'bigWalk' or 'smallWalk') end
        elseif self.velocity == 0 then
          if self.behavior.state ~= 'bigIdle' and self.behavior.state ~= 'smallIdle' then self.behavior:setState(self.big and 'bigIdle' or 'smallIdle') end
        end
      else
        self.behavior:setState(self.big and 'bigJump' or 'smallJump')
      end
    end

    if self.x+GlobalState.tx > 112 then GlobalState.tx = GlobalState.tx-self.dx end
    if self.velocity > 0x130 and self.direction == -1 and self.x == GlobalState.tx then self.velocity = 0x130 end

    for i = 1, len do
      local sprite = cols[i].other
      if sprite.collision == nil or sprite.collision == 'slide' then
        if cols[i].normal.y == 1 and self.jumpspeed < 0 then self.jumpspeed = 0 end
        if cols[i].normal.x ~= 0 and self.velocity > 0x130 then self.velocity = 0x130 end
      end

      if self.controllable then
        if sprite.type == 'flag' then
          sprite.collision = 'cross'
          self:setControllable(false)
          self.velocity = 0
          self.acceleration = 0
          self.jumpspeed = 0
          self.holdspeed = 0
          self.gravity = 0
          self.behavior:setState(self.big and 'bigSlide' or 'smallSlide')

        elseif sprite.enemy or sprite.type == 'shell' then
          self:hit(sprite, cols[i])

        elseif sprite.type == 'pipedown' and Input:pressed('down') then
          self:destroy()
          Event.dispatch('pipedown')

        elseif sprite.type == 'pipeexit' then
          self:destroy()
          Event.dispatch('pipeexit')

        elseif sprite.type == 'coin' then
          Sounds.coin:seek(0)
          Sounds.coin:play()
          sprite:destroy()

        elseif sprite.hit then
          sprite:hit(cols[i], self.big)
        end
      end
    end

    if self.collisionable then
      GlobalState.marioStanding = false
      local _, _, ms = GlobalState.world:check(self, self.x, self.y+1, function (_, other)
        if other.enemy or other.collision == false then return nil end
        return (other.collision == nil or other.collision ~= 'cross') and 'slide' or nil
      end)
      for _, m in pairs(ms) do if m.normal.y == -1 then GlobalState.marioStanding = true end end

      if self.y > VIRTUAL_HEIGHT then
        self:destroy()
        Event.dispatch('dead')
      end
    end
  end
end

function mario:draw ()
  local x, y = math.floor(0.5+self.x), math.floor(0.5+self.y)
  if self.behavior.frame.quad then
    if self.big then
      if self.behavior.frame.head then
        love.graphics.draw(Graphics.sprites, self.behavior.frame.head, x, y, 0, GlobalState.facingDirection, 1, GlobalState.facingDirection == 1 and 0 or 16, 0)
      end
      love.graphics.draw(Graphics.sprites, self.behavior.frame.quad, x, y+16, 0, GlobalState.facingDirection, 1, GlobalState.facingDirection == 1 and 0 or 16, 0)
    else
      if self.behavior.frame.head then
        love.graphics.draw(Graphics.sprites, self.behavior.frame.head, x, y-16, 0, GlobalState.facingDirection, 1, GlobalState.facingDirection == 1 and 0 or 16, 0)
      end
      love.graphics.draw(Graphics.sprites, self.behavior.frame.quad, x, y, 0, GlobalState.facingDirection, 1, GlobalState.facingDirection == 1 and 0 or 16, 0)
    end
  end
end

return mario

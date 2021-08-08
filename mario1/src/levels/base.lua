local level = Base:extend()

local sti = require 'libs/sti'

local mario = require 'src/sprites/mario'
local brick = require 'src/sprites/brick'
local block = require 'src/sprites/block'
local mushroom = require 'src/sprites/mushroom'
local up = require 'src/sprites/1up'
local goomba = require 'src/sprites/goomba'
local koopa = require 'src/sprites/koopa'
local castleflag = require 'src/sprites/castleflag'
local flag = require 'src/sprites/flag'
local wall = require 'src/sprites/wall'
local walltop = require 'src/sprites/walltop'
local coin = require 'src/sprites/coin'
local pipedown = require 'src/sprites/pipedown'
local pipeexit = require 'src/sprites/pipeexit'

function level:load (map, bgcolor, fromPipe)
  self.bgcolor = bgcolor
  self.map = sti(map, { 'bump' })
  GlobalState.world = Bump.newWorld(32)
  self.map:bump_init(GlobalState.world)

  GlobalState.tx = 0
  GlobalState.txlimit = self.txlimit
  GlobalState.facingDirection = 1
  GlobalState.frozeSprites = false
  GlobalState.marioStanding = true

  local spritesLayer = self:addLayer('sprites')
  local marioLayer = self:addLayer('mario')
  local fgLayer = self:addLayer('fg')

  for _, obj in pairs(self.map.objects) do
    if obj.name == 'mario' then
      self.mariopos = {obj.x, obj.y-16}
    elseif obj.name == 'flag' then
      spritesLayer.sprites[#spritesLayer.sprites+1] = flag(obj.x, obj.y-16)
    elseif obj.name == 'castleflag' then
      spritesLayer.sprites[#spritesLayer.sprites+1] = castleflag(obj.x, obj.y-16)
    elseif obj.type == 'mushroom' then
      spritesLayer.sprites[#spritesLayer.sprites+1] = mushroom(obj.x, obj.y-16, obj.properties.ref)
    elseif obj.type == 'up' then
      spritesLayer.sprites[#spritesLayer.sprites+1] = up(obj.x, obj.y-16, obj.properties.ref)
    elseif obj.type == 'goomba' then
      spritesLayer.sprites[#spritesLayer.sprites+1] = goomba(obj.x, obj.y-16)
    elseif obj.type == 'koopa' then
      spritesLayer.sprites[#spritesLayer.sprites+1] = koopa(obj.x, obj.y-16)
    elseif obj.type == 'coin' then
      spritesLayer.sprites[#spritesLayer.sprites+1] = coin(obj.x, obj.y-16)
    elseif obj.name == 'pipeup' then
      self.pipeup = {obj.x, obj.y}
    elseif obj.name == 'pipedown' then
      spritesLayer.sprites[#spritesLayer.sprites+1] = pipedown(obj.x, obj.y-16)
    elseif obj.name == 'pipeexit' then
      spritesLayer.sprites[#spritesLayer.sprites+1] = pipeexit(obj.x, obj.y-16)
    elseif obj.type == 'brick' then
      fgLayer.sprites[#fgLayer.sprites+1] = brick(obj.x, obj.y-16)
    elseif obj.type == 'block' then
      fgLayer.sprites[#fgLayer.sprites+1] = block(obj.x, obj.y-16, not obj.properties.invisible, obj.properties.ref)
    elseif obj.type == 'wall' then
      fgLayer.sprites[#fgLayer.sprites+1] = wall(obj.x, obj.y-16)
    elseif obj.type == 'walltop' then
      fgLayer.sprites[#fgLayer.sprites+1] = walltop(obj.x, obj.y-16)
    end
  end

  if fromPipe then
    marioLayer.sprites[#marioLayer.sprites+1] = mario(self.pipeup[1], self.pipeup[2])
  else
    marioLayer.sprites[#marioLayer.sprites+1] = mario(self.mariopos[1], self.mariopos[2])
  end

  if self.map.layers['Foreground'] then self.map:removeLayer('Foreground') end
  if self.map.layers['Sprites'] then self.map:removeLayer('Sprites') end
end

function level:addLayer (name, idx)
  local layer = self.map:addCustomLayer(name, idx)
  layer.sprites = {}

  layer.draw = function (this)
    for _, s in pairs(this.sprites) do
      if not s.destroyed and s.visible then s:draw() end
    end
  end

  layer.update = function (this, dt)
    local sprites = {}
    for _, s in pairs(this.sprites) do
      if not s.destroyed then sprites[#sprites+1] = s; s:update(dt) end
    end
    this.sprites = sprites
  end

  return layer
end

function level:destroy ()
  for _, s in pairs(self.map.layers['sprites'].sprites) do s:destroy() end
  for _, s in pairs(self.map.layers['fg'].sprites) do s:destroy() end
end

function level:update (dt)
  self.map:update(dt)
end

function level:render ()
  love.graphics.clear(unpack(self.bgcolor))
  GlobalState.tx = math.min(0, math.max(-GlobalState.txlimit, GlobalState.tx))
  self.map:draw(GlobalState.tx, 0)
  --love.graphics.setColor(1,0,0)
  --self.map:bump_draw(GlobalState.tx,0)
end

return level

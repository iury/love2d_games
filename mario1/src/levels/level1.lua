local level = BaseLevel:extend({ txlimit = 3136 })

function level:constructor (fromPipe)
  self:load('level1map.lua', {146/255,144/255,1}, fromPipe or false)
  Sounds.mainTheme:play()
end

return level

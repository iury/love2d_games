local level = BaseLevel:extend({ txlimit = 0 })

function level:constructor ()
  self:load('level1umap.lua', {0,0,0})
  Sounds.underworld:play()
end

return level

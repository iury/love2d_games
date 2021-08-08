local Level = {}

function Level.load (idx)
  if love.filesystem.getInfo('levels/' .. tostring(idx) .. '.txt') then
    local posY = 0
    local res = {lines={}}
    local data = love.filesystem.read('levels/' .. tostring(idx) .. '.txt')
    if data:sub(-1) ~= "\n" then data = data .. "\n" end
    for line in data:gmatch("(.-)\n") do
      posY = posY + 1
      if posY == 20 then break end
      if posY == 1 then
        res.background = line:sub(1,1)
      else
        local bricks = {}
        for posX = 1, 13 do
          local n = line:sub(posX, posX)
          bricks[#bricks+1] = n and tonumber(n) or -1
        end
        res.lines[#res.lines+1] = bricks
      end
    end
    return res
  else
    return nil
  end
end

return Level

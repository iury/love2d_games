local Grid = Base:extend()

function Grid:constructor (table)
  if table then
    self.table = table
  else
    self.table = {}
    self:generate()
  end
end

function Grid:clone ()
  local nt = {}
  for _, t in ipairs(self.table) do nt[#nt+1] = {unpack(t)} end
  return Grid(nt)
end

function Grid:swap (x1, y1, x2, y2)
  local t = self.table
  local v1, v2 = t[y1][x1], t[y2][x2]
  t[y1][x1] = v2
  t[y2][x2] = v1
  local m = self:matches()
  if #m > 0 then
    return true, m
  else
    t[y1][x1] = v1
    t[y2][x2] = v2
    return false
  end
end

function Grid:matches ()
  local t = self.table
  local ret = {}

  for x = 1, COLS do
    local acc, pv = 0, 0
    for y = 1, ROWS+1 do
      if (t[y] or {})[x] == pv then acc = acc + 1
      else
        if acc >= 3 then
          for i = acc, 1, -1 do ret[#ret+1] = {x, y-i} end
        end
        acc, pv = 1, (t[y] or {})[x]
      end
    end
  end

  for y = 1, ROWS do
    local acc, pv = 0, 0
    for x = 1, COLS+1 do
      if t[y][x] == pv then acc = acc + 1
      else
        if acc >= 3 then
          for i = acc, 1, -1 do ret[#ret+1] = {x-i, y} end
        end
        acc, pv = 1, t[y][x]
      end
    end
  end

  return ret
end

function Grid:generate ()
  local t = self.table
  repeat
    for i = 1, ROWS do t[i] = {0,0,0,0,0,0,0,0} end
    for y = 1, ROWS do
      for x = 1, COLS do
        local c
        repeat c = math.random(1,6)
        until c ~= t[y][x-2] and c ~= t[y][x+2] and c ~= (t[y-2] or {})[x] and c ~= (t[y+2] or {})[x]
        t[y][x] = c
      end
    end
  until self:validate()
end

function Grid:fill ()
  local t = self.table
  local ng = Grid()
  for y = 1, ROWS do
    for x = 1, COLS do
      if t[y][x] == 0 then t[y][x] = ng.table[y][x] end
    end
  end
end

function Grid:validate ()
  local clone = self:clone()
  local t = clone.table
  for y = 1, ROWS do
    for x = 1, COLS do
      local v = t[y][x+1]
      if v then
        t[y][x+1] = t[y][x]
        t[y][x] = v
        if #clone:matches() > 0 then return true end
        t[y][x] = t[y][x+1]
        t[y][x+1] = v
      end
      v = (t[y+1] or {})[x]
      if v then
        t[y+1][x] = t[y][x]
        t[y][x] = v
        if #clone:matches() > 0 then return true end
        t[y][x] = t[y+1][x]
        t[y+1][x] = v
      end
    end
  end
  return false
end

return Grid

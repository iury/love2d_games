local highScores = { blink = 0 }

function highScores:enter ()
  if not self.scores then self:load() end
end

function highScores:leave ()
  Sounds.gameEnd:stop()
end

function highScores:load ()
  self.scores = {}
  if love.filesystem.getInfo('data.brick') then
    local data = Json.decode(love.filesystem.read('data.brick'))
    self.scores = data.scores
  end
  for i = #self.scores + 1, 10 do
    self.scores[i] = {name = 'bob', score = 110000-i*10000}
  end
end

function highScores:save ()
  love.filesystem.write('data.brick', Json.encode({ scores = self.scores }))
end

function highScores:record (score)
  self.recording = true
  self.name = 'aaa'
  self.namePos = 1

  if not self.scores then self:load() end

  if score < self.scores[10].score then
    self.recording = false
  else
    for i = 1, 10 do
      if score >= self.scores[i].score then
        self.scorePos = i
        table.insert(self.scores, i, {name = 'aaa', score = score})
        self.scores[11] = nil
        break
      end
    end
  end
end

function highScores:update (dt)
  if not self.recording and (Input:pressed('back') or Input:pressed('action')) then
    Gamestate.pop()
  end

  if self.recording then
    self.blink = self.blink + dt
    if self.blink > 1 then self.blink = 0 end
  end

  if self.recording then
    if Input:pressed('action') and self.namePos == 4 then
      self.recording = false
      self.scores[self.scorePos].name = self.name
      self:save()
      Sounds.select:play()
      return
    end

    local updateName = function (char)
      self.name = self.name:sub(1, self.namePos-1) .. char .. self.name:sub(self.namePos+1, 3)
    end

    local byte = self.name:byte(self.namePos)

    self._tmr = self._tmr or -1
    if self._tmr >= 0 then self._tmr = self._tmr+self._dtmr*dt end
    if self._tmr > 1 then self._tmr = -1 end

    if Input:down('up') and self._tmr < 0 then
      self._tmr = 0
      self._dtmr = self._dtmr and 6 or 2
      byte = byte - 1
      if byte < 97 then byte = 122 end
      updateName(string.char(byte))
    elseif Input:down('down') and self._tmr < 0 then
      self._tmr = 0
      self._dtmr = self._dtmr and 6 or 2
      byte = byte + 1
      if byte > 122 then byte = 97 end
      updateName(string.char(byte))
    elseif Input:pressed('left') or Input:pressed('back') then
      self.namePos = math.max(1, self.namePos-1)
    elseif Input:pressed('right') or Input:pressed('action') then
      self.namePos = math.min(4, self.namePos+1)
    elseif Input:released('up') or Input:released('down') then
      self._tmr = -1
      self._dtmr = nil
    end
  end
end

function highScores:keypressed (key)
  if self.recording and self.namePos <= 3 and #key == 1 then
    local byte = key:byte()
    if byte >= 97 and byte <= 122 then
      self.name = self.name:sub(1, self.namePos-1) .. key:lower() .. self.name:sub(self.namePos+1, 3)
      self.namePos = self.namePos + 1
      Sounds.select:play()
    end
  end
end

function highScores:render ()
  love.graphics.clear(unpack(BackgroundColors.C))

  love.graphics.setFont(Fonts.large)
  love.graphics.printf('Bricks', 0, 50, VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(Fonts.medium)
  love.graphics.setColor(1,0,0)
  love.graphics.printf('High Scores', 0, 170, VIRTUAL_WIDTH, 'center')
  love.graphics.setColor(1,1,1)

  love.graphics.setFont(Fonts.medium)
  for i, score in ipairs(self.scores) do
    if self.recording and i == self.scorePos then
      love.graphics.setColor(0,1,0)
      for x = 1, 3 do
        if self.namePos ~= x or math.floor(self.blink * 9) % 3 > 0 then
          love.graphics.printf(self.name:sub(x, x), 100+(x-1)*24, 260+i*35, VIRTUAL_WIDTH)
        end
      end
    else
      love.graphics.setColor(1,1,1)
      love.graphics.printf(score.name, 100, 260+i*35, VIRTUAL_WIDTH)
    end
    love.graphics.printf(score.score, 0, 260+i*35, VIRTUAL_WIDTH-100, 'right')
  end
  love.graphics.setColor(1,1,1)
end

return highScores

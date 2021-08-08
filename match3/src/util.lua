function Printf (text, font, color, x, y, w, align, shadow)
  love.graphics.setFont(font)
  if shadow then
    love.graphics.setColor(0,0,0)
    love.graphics.printf(text, x+2, y+2, w, align or 'left')
  end
  love.graphics.setColor(unpack(color))
  love.graphics.printf(text, x, y, w, align or 'left')
end

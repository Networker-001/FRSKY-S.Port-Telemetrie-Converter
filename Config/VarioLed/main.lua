local translation = {
  {"Sensor", "Sensor"},
  {"SteigenFarbe", "Farbe Steigen"},
  {"SinkenFarbe", "Farbe Sinken"},
  {"RandAbstand", "Randabstand (px)"},
  {"Groesse", "Groesse (1=100%, 2=80%, 3=60%)"},
  {"Null-Zon 0.X", "Null-Zon 0.X"}
}

local function create()
  return {
    sensor = nil,
    climbColor = lcd.RGB(0, 255, 0),
    sinkColor = lcd.RGB(255, 0, 0),
    margin = 45,
    sizeSelection = 2,
    deadbandValue = 0
  }
end

local function options(widget, category, line)
  line:addSourceField(translation, function() return widget.sensor end, function(value) widget.sensor = value end)
  line:addColorField(translation, function() return widget.climbColor end, function(value) widget.climbColor = value end)
  line:addColorField(translation, function() return widget.sinkColor end, function(value) widget.sinkColor = value end)
  line:addIntegerField(translation, function() return widget.margin end, function(value) widget.margin = value end, 0, 100)
  line:addIntegerField(translation, function() return widget.sizeSelection end, function(value) widget.sizeSelection = value end, 1, 3)
  line:addIntegerField(translation, function() return widget.deadbandValue end, function(value) widget.deadbandValue = value end, 0, 20)
end

local function read(widget)
end

local function drawVerticalSegment(x, y, w, h, skew)
  lcd.drawFilledTriangle(x, y, x + w, y, x + skew, y + h)
  lcd.drawFilledTriangle(x + w, y, x + skew, y + h, x + w + skew, y + h)
end

local function drawHorizontalSegment(x, y, w, h, skewY)
  lcd.drawFilledRectangle(x + skewY, y, w, h)
end

local function drawDigit(x, y, digitWidth, digitHeight, num)
  local segments = {
    [0] = {true,  true,  true,  true,  true,  true,  false},
    [1] = {false, true,  true,  false, false, false, false},
    [2] = {true,  true,  false, true,  true,  false, true},
    [3] = {true,  true,  true,  true,  false, false, true},
    [4] = {false, true,  true,  false, false, true,  true},
    [5] = {true,  false,  true,  true,  false, true,  true},
    [6] = {true,  false,  true,  true,  true,  true,  true},
    [7] = {true,  true,  true,  false, false, false, false},
    [8] = {true,  true,  true,  true,  true,  true,  true},
    [9] = {true,  true,  true,  true,  false, true,  true},
    ["-"] = {false, false, false, false, false, false, true}
  }

  local segMatrix = segments[num]
  if not segMatrix then return end
  
  local th = math.max(2, math.floor(digitHeight * 0.06)) 
  local hW = math.floor(digitWidth)
  local hH = math.floor(digitHeight / 2)
  local gap = math.max(1, math.floor(th * 0.2))
  
  local skewFactor = 0.13 
  local skewTop = math.floor(hH * skewFactor)
  local skewMid = 0
  local skewBot = math.floor(-hH * skewFactor)

  if segMatrix[1] then drawHorizontalSegment(x + th + gap, y, hW - (th * 2) - (gap * 2), th, skewTop) end
  if segMatrix[6] then drawVerticalSegment(x + skewTop, y + th + gap, th, hH - th - (gap * 2), skewMid - skewTop) end
  if segMatrix[2] then drawVerticalSegment(x + hW - th + skewTop, y + th + gap, th, hH - th - (gap * 2), skewMid - skewTop) end
  if segMatrix[7] then drawHorizontalSegment(x + th + gap, y + hH - math.floor(th/2), hW - (th * 2) - (gap * 2), th, skewMid) end
  if segMatrix[5] then drawVerticalSegment(x + skewMid, y + hH + math.floor(th/2) + gap, th, hH - th - (gap * 2), skewBot - skewMid) end
  if segMatrix[3] then drawVerticalSegment(x + hW - th + skewMid, y + hH + math.floor(th/2) + gap, th, hH - th - (gap * 2), skewBot - skewMid) end
  if segMatrix[4] then drawHorizontalSegment(x + th + gap, y + digitHeight - th, hW - (th * 2) - (gap * 2), th, skewBot) end
end

local function paint(widget, w, h)
  if not widget.sensor then
    lcd.font(FONT_STD)
    lcd.drawText(10, 10, "Bitte Sensor waehlen...")
    return
  end

  local val = widget.sensor:value() or 0

  local deadbandThreshold = widget.deadbandValue * 0.1

  if val > deadbandThreshold then
    lcd.color(widget.climbColor)
  elseif val < -deadbandThreshold then
    lcd.color(widget.sinkColor)
  else
    lcd.color(lcd.RGB(255, 255, 255))
  end

  local valStr = string.format("%.1f", val)
  local len = string.len(valStr)
  
  local scaleFactor = 1.0
  if widget.sizeSelection == 2 then scaleFactor = 0.8
  elseif widget.sizeSelection == 3 then scaleFactor = 0.6 end
  
  local digitHeight = math.floor((h - 20) * scaleFactor)
  local digitWidth = math.floor(digitHeight * 0.48) 
  local digitSpacing = math.max(4, math.floor(digitWidth * 0.18))
  
  local dotBlockWidth = math.floor(digitWidth * 0.5) 

  local startY = math.floor(((h - 20) - digitHeight) / 2) + 10

  local totalWidth = 0
  for i = 1, len do
    local char = string.sub(valStr, i, i)
    if char == "." or char == "," then
      totalWidth = totalWidth + dotBlockWidth
    else
      totalWidth = totalWidth + digitWidth + digitSpacing
    end
  end
  if len > 0 then
    local lastChar = string.sub(valStr, len, len)
    if lastChar ~= "." and lastChar ~= "," then 
      totalWidth = totalWidth - digitSpacing 
    end
  end

  local skewBuffer = math.floor((digitHeight / 2) * 0.13)
  local startX = w - totalWidth - skewBuffer - widget.margin - math.floor(digitSpacing * 2)

  for i = 1, len do
    local char = string.sub(valStr, i, i)
    
    if char == "." or char == "," then
      local dotWidth = math.max(3, math.floor(digitHeight * 0.08))
      local exactDotX = startX + math.floor((dotBlockWidth - dotWidth) / 2)

      local skewDotTop = math.floor((digitHeight / 2) * 0.13)
      local skewDotBot = math.floor((digitHeight / 2 - dotWidth) * 0.13)
      
      lcd.drawFilledTriangle(exactDotX + skewDotTop, startY + digitHeight - dotWidth, exactDotX + dotWidth + skewDotTop, startY + digitHeight - dotWidth, exactDotX + skewDotBot, startY + digitHeight)
      lcd.drawFilledTriangle(exactDotX + dotWidth + skewDotTop, startY + digitHeight - dotWidth, exactDotX + skewDotBot, startY + digitHeight, exactDotX + dotWidth + skewDotBot, startY + digitHeight)
      
      startX = startX + dotBlockWidth
    elseif char == "-" then
      drawDigit(startX, startY, digitWidth, digitHeight, "-")
      startX = startX + digitWidth + digitSpacing
    else
      local num = tonumber(char)
      if num then
        drawDigit(startX, startY, digitWidth, digitHeight, num)
        startX = startX + digitWidth + digitSpacing
      end
    end
  end
end

local function wakeup(widget)
  lcd.invalidate()
end

local function init()
  system.registerWidget({
    name = "Vario LED XXL",
    create = create,
    options = options,
    read = read,
    paint = paint,
    wakeup = wakeup
  })
end

return {init = init}

local lastError = nil

local function create()
  return { sensor = nil, climbColor = lcd.RGB(0, 255, 0), sinkColor = lcd.RGB(255, 0, 0), margin = 45, sizeSelection = 2, AlertType = 0, deadbandValue = 0, deadbandLow = 0, precisionValue = 1, dividerValue = 0 }
end

local function wakeup(widget)
  lcd.invalidate()
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

local function paint(widget)
  local w, h = lcd.getWindowSize()
  
  if not widget.sensor then
    lcd.font(FONT_STD)
    lcd.drawText(20, 20, "Bitte Sensor waehlen...")
    return
  end
  
  lcd.font(FONT_STD)
  lcd.color(lcd.RGB(255, 255, 255))
  local sensorName = widget.sensor:name() or "Unbekannt"
  lcd.drawText(5, 5, sensorName)
  
  local val = widget.sensor:value() or 0
  local deadbandValue = widget.deadbandValue or 0
  local deadbandLow = widget.deadbandLow or 0
  local deadbandThreshold = widget.deadbandValue or 0
  local deadbandThresLow = widget.deadbandLow or 0
  local AlertType = widget.AlertType or 0
  if widget.precisionValue == 1 then
    deadbandThreshold = deadbandValue * 0.1
    deadbandThresLow = deadbandLow * 0.1
  else
    deadbandThreshold = deadbandValue * 0.1
    deadbandThresLow = deadbandLow * 0.1
  end

  local precision = widget.precisionValue or 1
  local isTimeFormat = false

  local divVal = widget.dividerValue or 0
  if divVal == 1 then
    isTimeFormat = true
    precision = 2
    local sign = 1
    if val < 0 then sign = -1 end
    local absVal = math.abs(val)
    local mins = math.floor(absVal / 60)
    local secs = math.floor(absVal % 60)
    val = sign * (mins + (secs / 100))
    deadbandThreshold = deadbandValue * 0.1
    deadbandThresLow = deadbandLow * 0.1
  elseif divVal == 2 then
    val = val / 100
  end

  if AlertType == 0 then
    lcd.color(widget.climbColor or lcd.RGB(255, 255, 255))
  end
  
  if AlertType == 1 then
    if val > deadbandThreshold then
      lcd.color(widget.climbColor or lcd.RGB(0, 255, 0))
    elseif val > deadbandThresLow then
      lcd.color(widget.sinkColor or lcd.RGB(255, 0, 0))
    else
      lcd.color(lcd.RGB(255, 255, 255))
    end
  end

  if AlertType == 2 then
    if val < deadbandThreshold then
      lcd.color(widget.climbColor or lcd.RGB(0, 255, 0))
    elseif val < deadbandThresLow then
      lcd.color(widget.sinkColor or lcd.RGB(255, 0, 0))
    else
      lcd.color(lcd.RGB(255, 255, 255))
    end
  end

  if AlertType == 3 then
    if val > deadbandThreshold then
      lcd.color(widget.climbColor or lcd.RGB(0, 255, 0))
    elseif val < -deadbandThresLow then
      lcd.color(widget.sinkColor or lcd.RGB(255, 0, 0))
    else
      lcd.color(lcd.RGB(255, 255, 255))
    end
  end

  if not isTimeFormat then
    local mult = 10 ^ precision
    if val >= 0 then
      val = math.floor(val * mult) / mult
    else
      val = math.ceil(val * mult) / mult
    end
  end

  local formatStr = "%." .. tostring(precision) .. "f"
  if isTimeFormat then
    local signStr = ""
    if val < 0 then signStr = "-" end
    local absVal = math.abs(val)
    local mins = math.floor(absVal)
    local secs = math.floor((absVal - mins) * 100 + 0.5)
    valStr = string.format("%s%d.%02d", signStr, mins, secs)
  else
    valStr = string.format(formatStr, val)
  end
  
  local len = string.len(valStr)
  
  local sizeSelection = widget.sizeSelection or 2
  local scaleFactor = 1.0
  if sizeSelection == 2 then scaleFactor = 0.8
  elseif sizeSelection == 3 then scaleFactor = 0.6
  elseif sizeSelection == 4 then scaleFactor = 0.4 end
  
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

  local margin = widget.margin or 45
  local skewBuffer = math.floor((digitHeight / 2) * 0.13)
  local startX = w - totalWidth - skewBuffer - margin

  for i = 1, len do
    local char = string.sub(valStr, i, i)
    
    if char == "." or char == "," then
      local dotWidth = math.max(3, math.floor(digitHeight * 0.08))
      local exactDotX = startX + math.floor((dotBlockWidth - dotWidth) / 2) - math.floor(digitSpacing * 2)

      if isTimeFormat then
        local timeDotX = exactDotX + math.floor(dotWidth * 0.9)
        local skewTop = math.floor((digitHeight * 0.75) * 0.13)
        local yTop = startY + math.floor(digitHeight * 0.25)
        lcd.drawFilledTriangle(timeDotX + skewTop, yTop, timeDotX + dotWidth + skewTop, yTop, timeDotX + skewTop, yTop + dotWidth)
        lcd.drawFilledTriangle(timeDotX + dotWidth + skewTop, yTop, timeDotX + skewTop, yTop + dotWidth, timeDotX + dotWidth + skewTop, yTop + dotWidth)

        local skewBot = math.floor((digitHeight * 0.35) * 0.13)
        local yBot = startY + math.floor(digitHeight * 0.65)
        lcd.drawFilledTriangle(timeDotX + skewBot, yBot, timeDotX + dotWidth + skewBot, yBot, timeDotX + skewBot, yBot + dotWidth)
        lcd.drawFilledTriangle(timeDotX + dotWidth + skewBot, yBot, timeDotX + skewBot, yBot + dotWidth, timeDotX + dotWidth + skewBot, yBot + dotWidth)
      else
        local skewDotTop = math.floor((digitHeight / 2) * 0.13)
        local skewDotBot = math.floor((digitHeight / 2 - dotWidth) * 0.13)
        lcd.drawFilledTriangle(exactDotX + skewDotTop, startY + digitHeight - dotWidth, exactDotX + dotWidth + skewDotTop, startY + digitHeight - dotWidth, exactDotX + skewDotBot, startY + digitHeight)
        lcd.drawFilledTriangle(exactDotX + dotWidth + skewDotTop, startY + digitHeight - dotWidth, exactDotX + skewDotBot, startY + digitHeight, exactDotX + dotWidth + skewDotBot, startY + digitHeight)
      end

      startX = startX + dotBlockWidth

    elseif char == "-" then
      drawDigit(startX, startY, digitWidth, digitHeight, "-")
      startX = startX or (startX + digitWidth + digitSpacing)
    else
      local num = tonumber(char)
      if num then
        drawDigit(startX, startY, digitWidth, digitHeight, num)
        startX = startX + digitWidth + digitSpacing
      end
    end
  end

  if lastError then
    lcd.color(lcd.RGB(255, 93, 93))
    pcall(lcd.font, FONT_XS)
    lcd.drawText(4, h - 16, "Vario error: " .. lastError)
  end
end

local function configure(widget)
  local function line(text) return form.addLine(text) end

  if widget.margin == nil or widget.margin == 0 then widget.margin = 45 end
  if widget.sizeSelection == nil or widget.sizeSelection == 0 then widget.sizeSelection = 2 end
  if widget.precisionValue == nil then widget.precisionValue = 1 end
  if widget.dividerValue == nil then widget.dividerValue = 0 end

  local ln = line("Sensor waehlen")
  form.addSourceField(ln, nil, function() return widget.sensor end, function(val) widget.sensor = val end, SOURCE_TELEMETRY)

  ln = line("Rand rechts")
  form.addNumberField(ln, nil, 0, 600, function() return widget.margin end, function(val) widget.margin = val end)

  ln = line("Groesse (1: 100% bis 4: 40%)")
  form.addNumberField(ln, nil, 1, 4, function() return widget.sizeSelection end, function(val) widget.sizeSelection = val end)

  ln = line("Nachkommastellen (0-2)")
  form.addNumberField(ln, nil, 0, 2, function() return widget.precisionValue end, function(val) widget.precisionValue = val end)

  ln = line("Divisor (0:aus, 1:Timer, 2:/100)")
  form.addNumberField(ln, nil, 0, 2, function() return widget.dividerValue end, function(val) widget.dividerValue = val end)

  ln = line("Trigger (0:aus, 1:>, 2:<, 3:Vario)")
  form.addNumberField(ln, nil, 0, 3, function() return widget.AlertType end, function(val) widget.AlertType = val end)

  ln = line("Trigger Wert unten (Wert*0.1)")
  form.addNumberField(ln, nil, 0, 99999, function() return widget.deadbandLow end, function(val) widget.deadbandLow = val end)

  ln = line("Trigger Farbe unten")
  form.addColorField(ln, nil, function() return widget.sinkColor end, function(val) widget.sinkColor = val end)
  
  ln = line("Trigger Wert oben (Wert*0.1)")
  form.addNumberField(ln, nil, 0, 99999, function() return widget.deadbandValue end, function(val) widget.deadbandValue = val end)

  ln = line("Trigger Farbe oben")
  form.addColorField(ln, nil, function() return widget.climbColor end, function(val) widget.climbColor = val end)

end

local function read(widget)
  pcall(function()
    widget.sensor = storage.read("sensor")
    widget.climbColor = storage.read("climbColor")
    widget.sinkColor = storage.read("sinkColor")
    widget.margin = storage.read("margin")
    widget.sizeSelection = storage.read("sizeSelection")
    widget.deadbandValue = storage.read("deadbandValue")
    widget.deadbandLow = storage.read("deadbandLow")
    widget.AlertType = storage.read("AlertType")
    widget.precisionValue = storage.read("precisionValue")
    widget.dividerValue = storage.read("dividerValue")
  end)
end

local function write(widget)
  pcall(function()
    storage.write("sensor", widget.sensor)
    storage.write("climbColor", widget.climbColor)
    storage.write("sinkColor", widget.sinkColor)
    storage.write("margin", widget.margin)
    storage.write("sizeSelection", widget.sizeSelection)
    storage.write("deadbandValue", widget.deadbandValue)
    storage.write("deadbandLow", widget.deadbandLow)
    storage.write("AlertType", widget.AlertType)
    storage.write("precisionValue", widget.precisionValue)
    storage.write("dividerValue", widget.dividerValue)
  end)
end

local function init()
  system.registerWidget({
    key = "BigLED",
    name = "BIG LED XXL",
    create = create,
    wakeup = wakeup,
    paint = paint,
    configure = configure,
    read = read,
    write = write,
    persistent = true,
    title = false,
  })
end

return { init = init }

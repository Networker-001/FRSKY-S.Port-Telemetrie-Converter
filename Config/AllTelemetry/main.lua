local s_list = {}
local ignore_sensors = {
    ["RSSI"] = true, ["Rssi"] = true, ["1RSS"] = true, ["2RSS"] = true,
    ["RQly"] = true, ["RQLY"] = true, ["TQly"] = true, ["TQLY"] = true,
    ["TRSS"] = true, ["RFMD"] = true, ["TPWR"] = true, ["Ant"] = true, ["Anta"] = true,
    ["RSNR"] = true, ["Rsnr"] = true, ["TSNR"] = true, ["Tsnr"] = true, ["ANT"] = true
}
local function formatValue(source, name)
    local val = source:value()
    if not val then return "---" end
    local unit = source:unit()
    local unitStr = ""
    if unit == UNIT_VOLT then unitStr = "V"
    elseif unit == UNIT_AMPERE then unitStr = "A"
    elseif unit == UNIT_MAH then unitStr = "mAh"
    elseif unit == UNIT_CELSIUS then unitStr = "°C"
    elseif unit == UNIT_METER then unitStr = "m"
    elseif unit == UNIT_METER_PER_SECOND then unitStr = "m/s"
    end
    if name == "Cels" or name == "Cells" then
        return string.format("%.2fV", val)
    end
    local text = source:text()
    if text and text ~= "" then
        return text
    else
        return string.format("%.2f%s", val, unitStr)
    end
end
local function init()
end
local function create()
    return {}
end
local function wakeup(widget)
    s_list = {}
    local sources = system.getSources()
    if not sources then return end
    local seen_names = {}
    local total_counts = {}
    local valid_sources = {}
    for _, src in ipairs(sources) do
        if src:type() == SOURCE_TYPE_TELEMETRY then
            local name = src:name()
            if name and name ~= "" and not ignore_sensors[name] then
                table.insert(valid_sources, src)
                total_counts[name] = (total_counts[name] or 0) + 1
            end
        end
    end
    for _, src in ipairs(valid_sources) do
        local name = src:name()
        seen_names[name] = (seen_names[name] or 0) + 1
        local displayName = name
        if total_counts[name] > 1 then
            displayName = string.format("%s-%d", name, seen_names[name])
        end
        table.insert(s_list, {
            name = displayName,
            val = formatValue(src, name)
        })
    end
end
local function paint(widget, x, y, w, h)
    local start_x = x + 10
    local start_y = y + 10
    local row_height = 30
    local max_rows = math.floor((h - 20) / row_height)
    if #s_list == 0 then
        lcd.drawText(start_x, start_y, "Keine relevanten Sensoren gefunden")
        return
    end
    for index, sensor in ipairs(s_list) do
        if index > max_rows * 2 then break end 
        local current_x = start_x
        local current_y = start_y + ((index - 1) % max_rows) * row_height
        if index > max_rows then
            current_x = start_x + math.floor(w / 2)
        end
        lcd.drawText(current_x, current_y, sensor.name)
        lcd.drawText(current_x + 110, current_y, sensor.val, FONT_BOLD)
    end
end
return {
    init = init,
    create = create,
    wakeup = wakeup,
    paint = paint
}

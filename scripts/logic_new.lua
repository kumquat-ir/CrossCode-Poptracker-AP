---@diagnostic disable: lowercase-global
function has(item, amount)
  local count = Tracker:ProviderCountForCode(item)
  amount = tonumber(amount)
  if not amount then
    return count > 0
  else
    return count == amount
  end
end

function region(mode, name)
  return Tracker:FindObjectForCode("@REGION/" .. mode .. "/" .. name).AccessibilityLevel == AccessibilityLevel.Normal
end

function countBotanics()
  count = 0

  if region("open", "open3") then count = count + 20 end
  if region("open", "open4.4") then count = count + 6 end
  if region("open", "open5") then count = count + 18 end
  if region("open", "open8") then count = count + 7 end
  if region("open", "open10") then count = count + 5 end
  if region("open", "open10.Mid") then count = count + 1 end
  if region("open", "open10.Left") then count = count + 6 end
  if region("open", "open10.Right") then count = count + 2 end
  if region("open", "open10.Infested") then count = count + 1 end
  if region("open", "open16") then count = count + 9 end
  if region("open", "open20") then count = count + 1 end
  if region("open", "open11") then count = count + 1 end

  if has("settingDlcOn") and region("open", "openDLC_Beach") then count = count + 6 end
  if has("settingDlcOn") and region("open", "openDLC_DungeonEntry") then count = count + 5 end

  return count
end

function botanics(amount)
  return countBotanics() / Tracker:ProviderCountForCode("op_BA") >= tonumber(amount)
end

function anyElement()
  return has("eleHeat") or has("eleCold") or has("eleShock") or has("eleWave")
end

function canGrind()
  return has("leafShade") or has("flameShade") or (has("settingsRhombusHubOpen") and has("iceShade"))
      or (has("settingsRhombusHubOpen") and has("seedShade"))
      or (has("settingsRhombusHubOpen") and has("starShade"))
end

function var(name)
  if name == "canGrind" then
    return canGrind()
  elseif name == "rhombusHubUnlock" then
    return has("settingsRhombusHubOpen")
  elseif name == "vwPassage" then
    return has("vwLockOff") or (has("vwLockOn") and has("meteorShade"))
  elseif name == "vtShadeLock" then
    local bosses = has("minesWon") and has("fajroWon") and has("sonajizWon") and has("zirvitarWon")
    local shades = has("flameShade") and has("iceShade") and has("boltShade") and has("dropShade")
    return
        has("settingVTGateOpen") or
        (has("settingVTGateBosses") and bosses) or
        (has("settingVTGateShades") and shades) or
        (has("settingVTGateBoth") and bosses and shades)
  end
end

function vareq(name, val, desired)
  desired = desired:lower() == "true"
  local currentval

  if name == "closedGaia" then
    if has("settingsGaiaGardenFullClose") then
      currentval = { ["on"] = true, ["full"] = true }
    elseif has("settingsGaiaGardenMinimalClose") then
      currentval = { ["on"] = true, ["minimal"] = true }
    elseif has("settingsGaiaGardenOpen") then
      currentval = { ["off"] = true }
    end
  elseif name == "allowBoosterGrinding" then
    if has("settingBoosterOn") then
      currentval = { ["on"] = true }
    elseif has("settingBoosterOff") then
      currentval = { ["off"] = true }
    end
  end

  return (currentval[val] ~= nil) == desired
end

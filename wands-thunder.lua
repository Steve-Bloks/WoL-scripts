local spellName = "thunder-spell"
for _, old in ipairs(spell:findSpells({ name = spellName })) do
  old:kill()
end
spell.name = spellName

local stick = Item:new("stick")
stick.name = "§f§lThunder Wand"
local player = spell.owner
---@cast player Player
player.mainHandItem = stick

local function castLightningAt(blockPos)
  for dx = -1, 1 do
    for dz = -1, 1 do
      local x = blockPos.x + dx + 0.5
      local y = blockPos.y + 1
      local z = blockPos.z + dz + 0.5
      spell:execute(string.format("/summon lightning_bolt %.1f %.1f %.1f", x, y, z))
      sleep(1)
    end
  end
end

local q = spell:collect("PlayerHandSwingEvent")
while true do
  local ev = q:next()
  ---@cast ev PlayerHandSwingEvent
  if ev.hand == "MAIN_HAND"
    and ev.player.mainHandItem
    and ev.player.mainHandItem.name == stick.name
  then
    local hit = ev.player:raycastBlock(999999)
    if hit and hit.type == "BLOCK" then
      castLightningAt(hit.blockPos)
    end
  end
end

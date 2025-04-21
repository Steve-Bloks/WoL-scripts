local spellName = "flower-spell"
for _, old in ipairs(spell:findSpells({ name = spellName })) do
  old:kill()
end
spell.name = spellName

local stick = Item:new("stick")
stick.name = "§1§lFlower Wand"
local player = spell.owner
---@cast player Player
player.mainHandItem = stick

local function plantFlowers(blockPos)
  for dx = -1, 1 do
    for dz = -1, 1 do
      local x = math.floor(blockPos.x + dx)
      local y = math.floor(blockPos.y + 1)
      local z = math.floor(blockPos.z + dz)
      local cmd = string.format("/setblock %d %d %d minecraft:dandelion", x, y, z)
      spell:execute(cmd)
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
      plantFlowers(hit.blockPos)
    end
  end
end

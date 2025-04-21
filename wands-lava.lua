local spellName = "lava-wand"
for _, old in ipairs(spell:findSpells({ name = spellName })) do
  old:kill()
end
spell.name = spellName

local stick = Item:new("stick")
stick.name = "§c§lLava Wand"
local player = spell.owner
---@cast player Player
player.mainHandItem = stick

local function placeLavaAt(blockPos)
  local x, y, z = blockPos.x, blockPos.y, blockPos.z
  spell:execute(string.format(
    "/execute unless block %d %d %d minecraft:lava run fill %d %d %d %d %d %d minecraft:lava",
    x,    y,   z,
    x-1, y+1, z-1,
    x+1, y+1, z+1
  ))
end

local evQueue = spell:collect("PlayerHandSwingEvent")
while true do
  local ev = evQueue:next()
  ---@cast ev PlayerHandSwingEvent
  if ev.hand == "MAIN_HAND"
     and ev.player.mainHandItem
     and ev.player.mainHandItem.name == stick.name
  then
    local hit = ev.player:raycastBlock(999999)
    if hit and hit.type == "BLOCK" then
      placeLavaAt(hit.blockPos)
    end
  end
end

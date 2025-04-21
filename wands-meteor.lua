local spellName = "fireball-wand"
for _, old in ipairs(spell:findSpells({ name = spellName })) do
  old:kill()
end
spell.name = spellName

local wand = Item:new("stick")
wand.name = "§e§lMeteor Wand"
local player = spell.owner
---@cast player Player
player.mainHandItem = wand

local function spawnFireballRain(centerPos)
  for i = 1, 10 do
    local dx = math.random(-7, 7)
    local dz = math.random(-7, 7)
    local x = centerPos.x + dx + 0.5
    local z = centerPos.z + dz + 0.5
    local y = centerPos.y + 20

    spell:execute(string.format(
      [[/summon fireball %.1f %.1f %.1f {
        power:[0.0,-1.0,0.0],
        direction:[0.0,-1.0,0.0],
        Motion:[0.0,-1.0,0.0],
        ExplosionPower:3.5,
        life:2
      }]],
      x, y, z
    ))
  end
end

local swingEvents = spell:collect("PlayerHandSwingEvent")

while true do
  local success, event = pcall(function()
    return swingEvents:next()
  end)

  if success and event then
    ---@cast event PlayerHandSwingEvent
    if event.hand == "MAIN_HAND"
      and event.player.mainHandItem
      and event.player.mainHandItem.name == wand.name
    then
      local hit = event.player:raycastBlock(999999)
      if hit and hit.type == "BLOCK" then
        spawnFireballRain(hit.blockPos)
      end
    end
  end

  sleep(1)
end

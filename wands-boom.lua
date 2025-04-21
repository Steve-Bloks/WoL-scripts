local spellName = "eye-blast"
for _, old in ipairs(spell:findSpells({ name = spellName })) do
  old:kill()
end
spell.name = spellName

local wand = Item:new("stick")
wand.name = "§4§lBoom Wand"
local player = spell.owner
---@cast player Player
player.mainHandItem = wand

local q = spell:collect("PlayerHandSwingEvent")

while true do
  local ev = q:next()
  ---@cast ev PlayerHandSwingEvent
  if ev.hand == "MAIN_HAND"
    and ev.player.mainHandItem
    and ev.player.mainHandItem.name == wand.name
  then
    local hit = ev.player:raycastBlock(100)
    if hit and hit.type == "BLOCK" then
      local start = ev.player.eyePos
      local target = hit.blockPos

      local dx = target.x + 0.5 - start.x
      local dy = target.y + 0.5 - start.y
      local dz = target.z + 0.5 - start.z

      local length = math.sqrt(dx*dx + dy*dy + dz*dz)
      dx, dy, dz = dx / length, dy / length, dz / length

      local speed = 3
      local mx, my, mz = dx * speed, dy * speed, dz * speed

      local x, y, z = start.x, start.y, start.z

      local summonCmd = string.format(
        '/summon fireball %.2f %.2f %.2f {power:[%.2f,%.2f,%.2f],direction:[%.2f,%.2f,%.2f],Motion:[%.2f,%.2f,%.2f],ExplosionPower:50}',
        x, y, z,
        dx, dy, dz,
        dx, dy, dz,
        mx, my, mz
      )

      spell:execute(summonCmd)
    end
  end
end

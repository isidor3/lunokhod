local floor = math.floor
local ceil = math.ceil

local d = require "dice"

local Character = {}
Character.str = 10
Character.dex = 10
Character.con = 10
Character.int = 10
Character.wis = 10
Character.cha = 10

local skill = {}
skill.__index = skill
setmetatable(skill, skill)

function skill:new(name, ability)
  return setmetatable({name=name, ability=ability, ranks=0, class=false}, skill)
end

Character.skillObj = skill
Character.skills = {
 __character = Character,
 Acrobatics = skill:new("Acrobatics", "dex"),
 Appraise = skill:new("Appraise", "int"),
 Bluff = skill:new("Bluff", "cha"),
 Climb = skill:new("Climb", "str"),
 --etc...
}

function Character:mod(score) return floor(self[score]/2) - 5 end 

function Character:skillRoll(skillName) 
  local skill = self.skills[skillName]
  if skill == nil then error("Cannot roll against untrained skill ".. skillName) end
  
  return d(20) + skill.ranks + Character:mod(skill.ability) + ((skill.class and skill.ranks > 0) and 3 or 0)
end

return Character
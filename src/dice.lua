local random = math.random
local mathMin = math.min
local mathMax = math.max
math.randomseed(os.time())
math.random(200) math.random(200) math.random(200)

local mt = {}

function mt.newDice(min, max, ev, ex, f) 
  --ignore the complexities of dealing with negative numbers elsewhere and just fix it here
  local realMin = mathMin(min,max)
  local realMax = mathMax(min,max)
  return setmetatable({min=realMin, max=realMax, ev=ev, ex=ex, f=f, __dice=true}, mt)
end

function mt.__add(lhs, rhs)
  if type(lhs) == "table" and lhs.__dice then
    if type(rhs) == "number" then
      return mt.newDice(lhs.min+rhs, lhs.max+rhs, lhs.ev+rhs, lhs.ex+rhs, lhs.f.." + "..rhs)
    elseif type(rhs) == "table" and rhs.__dice then
      return mt.newDice(lhs.min+rhs.min, lhs.max+rhs.max, lhs.ev+rhs.ev, lhs.ex+rhs.ex, lhs.f.." + ("..rhs.f..")")
    else
      error("cannot add dice and non-dice: "..type(rhs))
    end
  elseif type(rhs) == "table" and rhs.__dice then
    if type(lhs) == "number" then
      return mt.newDice(rhs.min+lhs,rhs.max+lhs, rhs.ev+lhs, rhs.ex+lhs, lhs.." + "..rhs.f)
    else
      error("cannot add dice and non-dice: "..type(lhs))
    end
  else
    error "you set a dice metatable to a non-dice object"
  end
end
  
function mt.__sub(lhs, rhs)
  if type(lhs) == "table" and lhs.__dice then
    if type(rhs) == "number" then
      return mt.newDice(lhs.min-rhs, lhs.max-rhs, lhs.ev-rhs, lhs.ex-rhs, lhs.f.." - "..rhs)
    elseif type(rhs) == "table" and rhs.__dice then
      return mt.newDice(lhs.min-rhs.max, lhs.max-rhs.min, lhs.ev-rhs.ev, lhs.ex-rhs.ex, lhs.f.." - ("..rhs.f..")")
    else
      error("Cannot subtract dice and non-dice: "..type(rhs))
    end
  elseif type(rhs) == "table" and rhs.__dice then
    if type(lhs) == "number" then
      return mt.newDice(lhs-rhs.min, lhs-rhs.max, lhs-rhs.ev, lhs-rhs.ex, lhs.." - "..rhs.f)
    else
      error("Cannot subtract dice from non-dice: "..type(lhs))
    end
  else
    error "you set a dice metatable to a non-dice object"
  end
end

function mt.__mul(lhs, rhs)
  if type(lhs) == "table" and lhs.__dice then
    if type(rhs) == "number" then
      return mt.newDice(lhs.min*rhs, lhs.max*rhs, lhs.ev*rhs, lhs.ex*rhs, lhs.f.." * "..rhs)
    elseif type(rhs) == "table" and rhs.__dice then
      return mt.newDice(lhs.min*rhs.min, lhs.max*rhs.max, lhs.ev*rhs.ev, lhs.ex*rhs.ex, lhs.f.." * ("..rhs.f..")")
    else
      error("cannot multiply dice and non-dice: "..type(rhs))
    end
  elseif type(rhs) == "table" and rhs.__dice then
    if type(lhs) == "number" then
      return mt.newDice(rhs.min*lhs,rhs.max*lhs, rhs.ev*lhs, rhs.ex*lhs, lhs.." * "..rhs.f)
    else
      error("cannot multiply dice and non-dice: "..type(lhs))
    end
  else
    error "you set a dice metatable to a non-dice object"
  end
end


  
function mt.__unm(lhs)
  if type(lhs) == "table" and lhs.__dice then
    return mt.newDice(-lhs.max, -lhs.min, -lhs.ev, -lhs.ex, "-("..lhs.f..")")
  else       
    error "you set a dice metatable to a non-dice object"
  end
end 
  
mt.__tostring = function(self)
  return "{ min="..self.min..", max="..self.max..", expected="..self.ev..", result="..self.ex..", formula= "..self.f.." }"
end

local function oneDice(x)
  local min = 1
  local max = x
  local ev = x/2 + 0.5
  local ex = random(x)
  local f = "d"..x..":"..ex..""
  return mt.newDice(min,max,ev,ex,f)
end

local function xDice(x, y)
  local f = x.."d"..y..":"
  local summedDice = 0
  for i=1,x do
      local newDice = oneDice(y)
      f = f..newDice.ex
      if x ~= i then f = f.."," end
      summedDice = summedDice + newDice
  end
  f = f.."="..summedDice.ex
  summedDice.f = f
  return summedDice
end

return function(x, y) if y == nil then return oneDice(x) else return xDice(x,y) end end

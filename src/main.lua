local d = require "dice"

local function main()
  print(12 - d(20) + 2*(d(3,10) + 2) + 3)
end

main()

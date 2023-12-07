local function map(value, inMin, inMax, outMin, outMax)
  -- Map a value from one range to another
  local t = (value - inMin) / (inMax - inMin)
  return (1 - t) * outMin + t * outMax
end

local function sum(t)
  local sum = 0
  for _, v in pairs(t) do
      sum = sum + v
  end
  return sum
end

return {
  map = map,
  sum = sum
}

local function map(value, inMin, inMax, outMin, outMax)
  -- Map a value from one range to another
  local t = (value - inMin) / (inMax - inMin)
  return (1 - t) * outMin + t * outMax
end

return {
  map = map
}

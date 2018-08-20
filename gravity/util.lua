function distance(x1, y1, x2, y2) return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2) end

function middle(x, y, z) return math.max(math.min(x, y), math.min(math.max(x, y), z)) end
local f = io.open("data.txt", "r")
assert(f, "where is the data maaaaaaan")
TILEMAP = ""
COLUMNS = 0
ROWS = 0

while true do
    local line = f:read "*l"
    if  line == nil then break end
    ROWS = ROWS + 1
    COLUMNS = string.len(line)
    TILEMAP = TILEMAP .. string.sub(line, 1)
end

function T(x, y)
    if x < 1 or y < 1 or x > COLUMNS or y > ROWS then
        return nil
    end
    local i = x + (y - 1) * COLUMNS
    return string.sub(TILEMAP, i, i)
end

local startx = -1
local starty = -1
for x = 1, COLUMNS do
    for y = 1, ROWS do
        local t = T(x, y)
        if t == "S" then
           startx = x
           starty = y
           goto next
        end
    end
    ::next::
end

local conn = {}

local right = T(startx + 1, starty)
if right == "-" or right == "7" or right == "J" then
   table.insert(conn, {startx + 1, starty})
end
local left = T(startx - 1, starty)
if left == "-" or left == "L" or left == "F" then
   table.insert(conn, {startx - 1, starty})
end
local up = T(startx, starty - 1)
if up == "|" or up == "7" or up == "F" then
   table.insert(conn, {startx, starty - 1})
end
local down = T(startx, starty + 1)
if down == "|" or down == "L" or down == "J" then
   table.insert(conn, {startx, starty + 1})
end

local function next_pipe(px, py, x, y)
    local t = T(x, y)
    if t == "|" then
        if py > y then return x,y-1 else return x,y+1 end
    end
    if t == "-" then
        if px > x then return x-1,y else return x+1,y end
    end
    if t == "L" then
        if py < y then return x+1,y else return x,y-1 end
    end
    if t == "J" then
        if py < y then return x-1,y else return x,y-1 end
    end
    if t == "7" then
        if px < x then return x,y+1 else return x-1,y end
    end
    if t == "F" then
        if px > x then return x,y+1 else return x+1,y end
    end
    error("WTF")
    return x, y
end

local c = conn[1]
local px = startx
local py = starty
local d = 1
local loop = {}

loop[startx + starty * COLUMNS] = true
loop[c[1] + c[2] * COLUMNS] = true

while not (c[1] == startx and c[2] == starty) do
    local nx, ny = next_pipe(px, py, c[1], c[2])
    loop[nx + ny * COLUMNS] = true

    d = d + 1
    px = c[1]
    py = c[2]

    c[1] = nx
    c[2] = ny
end

print("Part A: ", d / 2)

local inside = 0
for x = 1, COLUMNS do
    for y = 1, ROWS do
        if loop[x + y * COLUMNS] then goto cont end

        local i = 1
        local collisions = 0
        while true do
            local v = T(x + i, y)
            if v == nil then break end

            local s2 = x + i + y * COLUMNS

            if loop[s2] and v ~= "-" and v ~= "L" and v ~= "J" and v ~= "S" then collisions = collisions + 1 end
            i = i + 1
        end

        -- Even-odd rule
        if math.fmod(collisions, 2) ~= 0 then
            inside = inside + 1
        end

        ::cont::
    end
end

print("Part B: ", inside)

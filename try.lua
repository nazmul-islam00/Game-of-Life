Class = require "class"
require "Box"


WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
GRID_WIDTH = 16
GRID_HEIGHT = 16
GRID_START_X = 35
GRID_START_Y  = 35
BOX_WIDTH = 25
BOX_HEIGHT = 25
BOX_GAP = 2
BOXES = {}

for row = 0, GRID_HEIGHT - 1 do
    BOXES[row] = {}
    for col = 0, GRID_WIDTH - 1 do
        box = Box(
            GRID_START_X + col * (BOX_WIDTH + BOX_GAP),
            GRID_START_Y + row * (BOX_HEIGHT + BOX_GAP),
            BOX_WIDTH,
            BOX_HEIGHT
        )
        BOXES[row][col] = box
    end
end



neighbors = {}
change_x = {-1, -1, -1, 0, 0, 1, 1, 1}
change_y = {-1, 0, 1, -1, 1, -1, 0, 1}

for row = 0, GRID_HEIGHT - 1 do
    neighbors[row] = {}
    for col = 0, GRID_WIDTH - 1 do
        local count = 0
        for i = 1, 8 do
            local _x = row + change_x[i] 
            local _y = col + change_y[i]
            if 0 <= _x and _x < GRID_HEIGHT and 0 <= _y and _y < GRID_WIDTH then
                count = count + 1
            end
        end
        neighbors[row][col] = count
    end
end

for row = 0, GRID_HEIGHT - 1 do
    for col = 0, GRID_WIDTH - 1 do
        print(row, col, neighbors[row][col])
    end
end


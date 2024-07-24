push = require "push"
Class = require "class"
require "Box"
require "Grid"


-- WINDOW_WIDTH = 599
-- WINDOW_HEIGHT = 599
WINDOW_WIDTH = 1080
WINDOW_HEIGHT = 800
PASSED_TIME = 0
BOXES = {}
CONFIG = {
    ["choice"] = {
        GRID_WIDTH = 4,
        GRID_HEIGHT = 4,
        -- GRID_START_X = 108,
        -- GRID_START_Y = 108,
        GRID_START_X = 338,
        GRID_START_Y = 198,
        GRID_GAP = 11,
        BOX_WIDTH = 80,
        BOX_HEIGHT = 80,
        BOX_GAP = 21
    },
    ["game"] = {
        -- GRID_WIDTH = 16,
        -- GRID_HEIGHT = 16,
        -- GRID_START_X = 32,
        -- GRID_START_Y = 32,
        -- GRID_GAP = 5,
        -- BOX_WIDTH = 25,
        -- BOX_HEIGHT = 25,
        -- BOX_GAP = 9
        GRID_WIDTH = 30,
        GRID_HEIGHT = 30,
        GRID_START_X = 198,
        GRID_START_Y = 58,
        GRID_GAP = 4,
        BOX_WIDTH = 16,
        BOX_HEIGHT = 16,
        BOX_GAP = 7
    },
    -- OFFSET_WIDTH = 6,
    -- OFFSET_HEIGHT = 6
    OFFSET_WIDTH = 13,
    OFFSET_HEIGHT = 13,
    REFRESH_TIME = 0.2
}


function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setTitle("Game of Life")
    smallFont = love.graphics.newFont("font.ttf", 20)
    mediumFont = love.graphics.newFont("font.ttf", 32)
    largeFont = love.graphics.newFont("font.ttf", 40)
    extraLargeFont = love.graphics.newFont("font.ttf", 48)
    push:setupScreen(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
    gamestate = "choice" --initialize gamestate
    config = CONFIG[gamestate] -- initialize config 
    grid = Grid(config) -- initialize grid
    initialize_boxes() -- initialize boxes
end


function love.resize(width, height)
    push:resize(width, height)
end


function love.update(dt) 
    PASSED_TIME = PASSED_TIME + dt
    if PASSED_TIME < CONFIG.REFRESH_TIME then
        return
    end

    love.graphics.clear()
    PASSED_TIME = 0
    
    if gamestate == "game" then
        local change_x = {-1, -1, -1, 0, 0, 1, 1, 1}
        local change_y = {-1, 0, 1, -1, 1, -1, 0, 1}
        local neighbors = {}

        for row = 0, config.GRID_HEIGHT - 1 do
            neighbors[row] = {}
            for col = 0, config.GRID_WIDTH - 1 do
                local count = 0

                for i = 1, 8 do
                    local _x = row + change_x[i]
                    local _y = col + change_y[i]

                    if 
                        0 <= _x and
                        _x < config.GRID_HEIGHT and
                        0 <= _y and
                        _y < config.GRID_WIDTH and
                        BOXES[_x][_y].status 
                    then 
                        count = count + 1
                    end
                end
                neighbors[row][col] = count -- store alive neighbors' count
            end
        end

        -- if cell is active and has no neighbors or more than 5 neighbors then make it inactive
        -- if cell is inactive and has more than 3 neighbors make it active
        -- if cell is at border make it inactive

        for row = 0, config.GRID_HEIGHT - 1 do
            for col = 0, config.GRID_WIDTH - 1 do
                if BOXES[row][col].status then
                    if 
                        neighbors[row][col] < 1 or 
                        neighbors[row][col] > 5 or 
                        row == 0 or 
                        row == config.GRID_HEIGHT - 1 or
                        col == 0 or
                        col == config.GRID_WIDTH - 1
                    then
                        BOXES[row][col].status = false
                    end

                else
                    if neighbors[row][col] >=3 then
                        BOXES[row][col].status = true
                    end
                end   
            end
        end
    end
end


function love.draw()
    grid:render()

    print_instructions()

    for row = 0, config.GRID_HEIGHT - 1 do
        for col = 0, config.GRID_WIDTH - 1 do
            BOXES[row][col]:render()
        end
    end
end


function print_instructions()
    if gamestate == "choice" then
        love.graphics.setFont(extraLargeFont)
        love.graphics.print("Conway's Game of Life", 250, 60)

        love.graphics.setFont(largeFont)
        love.graphics.print("Pick configuration", 340, 620)

        love.graphics.setFont(mediumFont)
        love.graphics.print("Select - s", 280, 680)
        love.graphics.print("Cancel - u", 600, 680)
        love.graphics.print("Start - space", 280, 720)
        love.graphics.print("Quit - esc", 600, 720)
        

    elseif gamestate == "game" then
        love.graphics.setFont(smallFont)
        love.graphics.print("Quit - esc", 280, 770)
        love.graphics.print("Return - space", 600, 770)
    end
end


function initialize_boxes()
    for row = 0, config.GRID_HEIGHT - 1 do
        BOXES[row] = {}
        for col = 0, config.GRID_WIDTH - 1 do
            BOXES[row][col] = Box(
                config.GRID_START_X + col * (config.BOX_WIDTH + config.BOX_GAP),
                config.GRID_START_Y + row * (config.BOX_HEIGHT + config.BOX_GAP),
                config.BOX_WIDTH,
                config.BOX_HEIGHT
            )
        end
    end
end


function alter_gamestate()
    if gamestate == "choice" then
        gamestate = "game"
        config = CONFIG[gamestate]
        local selected_status = {}

        for row = 0, CONFIG["choice"].GRID_HEIGHT - 1 do
            selected_status[row] = {}
            for col = 0, CONFIG["choice"].GRID_WIDTH - 1 do
                selected_status[row][col] = BOXES[row][col].status
            end
        end
        
        initialize_boxes()
        initialize_grid()

        for row = 0, CONFIG["choice"].GRID_HEIGHT - 1 do
            for col = 0, CONFIG["choice"].GRID_WIDTH - 1 do
                BOXES[CONFIG.OFFSET_HEIGHT + row][CONFIG.OFFSET_WIDTH + col].status = selected_status[row][col]
            end
        end

    else
        gamestate = "choice"
        config = CONFIG[gamestate]
        initialize_grid()
        initialize_boxes()
    end
end


function love.keypressed(key)
    if key == "escape" then
        love.event.quit()

    elseif key == "space" then
        alter_gamestate()

    elseif  key == "s" and gamestate == "choice" then
        for row = 0, config.GRID_HEIGHT - 1 do
            for col = 0, config.GRID_WIDTH - 1 do
                box = BOXES[row][col]
    
                if 
                    box.x <= love.mouse.getX() and
                    love.mouse.getX() <= box.x + box.width  and 
                    box.y <= love.mouse.getY() and
                    love.mouse.getY() <= box.y + box.height
                then
                    box.status = true
                end
            end
        end

    elseif  key == "u" and gamestate == "choice" then
        for row = 0, config.GRID_HEIGHT - 1 do
            for col = 0, config.GRID_WIDTH - 1 do
                box = BOXES[row][col]
    
                if 
                    box.x <= love.mouse.getX() and
                    love.mouse.getX() <= box.x + box.width  and 
                    box.y <= love.mouse.getY() and
                    love.mouse.getY() <= box.y + box.height
                then
                    box.status = false
                end
            end
        end
    end
end


function initialize_grid()
    grid = Grid(config)
end
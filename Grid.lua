Grid = Class{}


function Grid:init(config)
    self.grid_start_x = config.GRID_START_X
    self.grid_start_y = config.GRID_START_Y
    self.grid_width = config.GRID_WIDTH
    self.grid_height = config.GRID_HEIGHT
    self.grid_gap = config.GRID_GAP
    self.box_width = config.BOX_WIDTH
    self.box_height = config.BOX_HEIGHT
    self.box_gap = config.BOX_GAP
end


function Grid:render()
    for row = 0, self.grid_width do
        love.graphics.line(
            self.grid_start_x - self.grid_gap,
            self.grid_start_y + row * (self.box_height + self.box_gap) - self.grid_gap,
            self.grid_start_x + self.grid_width * (self.box_width + self.box_gap) - self.grid_gap,
            self.grid_start_y + row * (self.box_height + self.box_gap) - self.grid_gap
        )
    end

    for col = 0, self.grid_height do
        love.graphics.line(
            self.grid_start_x + col * (self.box_width + self.box_gap) - self.grid_gap,
            self.grid_start_y - self.grid_gap,
            self.grid_start_x + col * (self.box_width + self.box_gap) - self.grid_gap,
            self.grid_start_y + self.grid_height * (self.box_height + self.box_gap) - self.grid_gap
        )
    end
end
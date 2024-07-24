Box = Class{}


function Box:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.status = false
end


function Box:render()
    if self.status then 
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    else 
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    end
end
PIPE_IMAGE = love.graphics.newImage('images/pipe.png')
PIPE_HEIGHT = 288
PIPE_WIDTH = 70
Pipe = Class{}

function Pipe:init(orientation, y)
    self.width = PIPE_IMAGE:getWidth()
    self.height = PIPE_HEIGHT
    self.x = VIRTUAL_WIDTH
    self.y = y
    self.orientation = orientation
end

function Pipe:update(dt)

end

function Pipe:render()
    love.graphics.draw(
        PIPE_IMAGE,
        self.x,
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y),
        0,
        1,
        (self.orientation == 'top' and -1 or 1)
    )
end
PIPE_IMAGE = love.graphics.newImage('pipe.png')

Pipe = Class{}

PIPE_SCROLL_SPEED = -60
function Pipe:init(x, y)
    self.width = PIPE_IMAGE:getWidth()
    self.height = PIPE_IMAGE:getHeight()
    self.x = VIRTUAL_WIDTH
    self.y = math.random(VIRTUAL_HEIGHT/2, VIRTUAL_HEIGHT- 10)
end

function Pipe:update(dt)
    self.x = self.x + PIPE_SCROLL_SPEED * dt
end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, self.y)
end
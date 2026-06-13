PipePair = Class{}
local GAP_HEIGHT = 90
PIPE_SCROLL_SPEED = -60
function PipePair:init(y)
    self.x = VIRTUAL_WIDTH + 30
    self.y = y
    self.pipes = {
        ['top'] = Pipe('top', self.y),
        ['bottom'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }
    self.remove = false 
end

function PipePair:update(dt)
    if self.x > -PIPE_WIDTH then
        self.x = self.x + dt * PIPE_SCROLL_SPEED
        self.pipes['top'].x = self.x
        self.pipes['bottom'].x = self.x
    else 
        self.remove = true
    end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do 
        pipe:render()
    end
end
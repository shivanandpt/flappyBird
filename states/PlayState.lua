
PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.bird = Bird()
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
    self.pipePairs = {}
    self.timer = 0
    self.score = 0
end

function PlayState:update(dt)
    if (self.timer > 2) then
        self.lastY = math.max(-PIPE_HEIGHT + 10,
        math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        table.insert(self.pipePairs, PipePair(self.lastY))
        self.timer = 0
    end
    self.timer = self.timer + dt
    
    for key, pair in pairs(self.pipePairs) do 
        pair:update(dt)
        for _, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                gSound['explosion']:play()
                gSound['hurt']:play()
                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end
    end
    if self.bird.y > VIRTUAL_HEIGHT - self.bird.height then
        gSound['explosion']:play()
        gSound['hurt']:play()
        gStateMachine:change('score', {
                score = self.score
        })
    end
    self.bird:update(dt)
    for _, pair in pairs(self.pipePairs) do
        if not pair.scored and pair.x < self.bird.x + self.bird.width then
            gSound['score']:play()
            self.score = self.score + 1
            pair.scored = true
        end
    end 
    for key, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, key)
        end
    end
end

function PlayState:render()
    self.bird:render()
    for _, pair in pairs(self.pipePairs) do 
        pair:render()
    end
end



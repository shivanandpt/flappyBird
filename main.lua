
-- virtual resolution handling library
push = require 'push'
Class = require 'class'
require 'Bird'
require 'Pipe'
require 'PipePair'
-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local backgroundScroll = 0
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413
local GROUND_LOOPING_POINT = 514
local spawnTimer = 0
pipePairs = {}

local lastY = -PIPE_HEIGHT + math.random(80) + 20


function love.load()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- images we load into memory from files to later draw onto the screen
    background = love.graphics.newImage('background.png')
    ground = love.graphics.newImage('ground.png')
    bird = Bird()
    -- app window title
    love.window.setTitle('Fifty Bird')

    -- initialize window
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
    love.keyboard.keysPressed = {}
    -- initialize our virtual resolution
    push.setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, { upscale = 'normal' })
end

function love.resize(w, h)
    push.resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'space' then
        -- make it fly
    end
end

function love.update(dt)
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT

    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    if (spawnTimer > 2) then
        local y = math.max(-PIPE_HEIGHT + 10,
    math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        lastY = y
        table.insert(pipePairs, PipePair(y))
        spawnTimer = 0
    end
    spawnTimer = spawnTimer + dt
    bird:update(dt)
    for key, pair in pairs(pipePairs) do 
        pair:update(dt)
    end
    for key, pair in pairs(pipePairs) do
        if pair.remove then
            table.remove(pipePairs, key)
        end
    end
    love.keyboard.keysPressed = {}
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    end 
    return false
end

function love.draw()
    push.start()

    -- draw the background starting at top left (0, 0)
    love.graphics.draw(background, -backgroundScroll, 0)
    for _, pair in pairs(pipePairs) do 
        pair:render()
    end 
    -- draw the ground on top of the background, toward the bottom of the screen
    love.graphics.draw(ground, -backgroundScroll, VIRTUAL_HEIGHT - 16)
    bird:render()
    push.finish()
end

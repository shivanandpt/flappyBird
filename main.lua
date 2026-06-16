
-- virtual resolution handling library
push = require 'push'
Class = require 'class'
require 'Bird'
require 'Pipe'
require 'PipePair'
require 'StateMachine'
require 'states.BaseState'
require 'states.PlayState'
require 'states.TitleScreenState'
require 'states.ScoreState'
-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local backgroundScroll = 0
local groundScroll = 0
local scrolling = true

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413
local GROUND_LOOPING_POINT = 514

function love.load()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- images we load into memory from files to later draw onto the screen
    background = love.graphics.newImage('background.png')
    ground = love.graphics.newImage('ground.png')
    
    -- app window title
    love.window.setTitle('Fifty Bird')
    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    -- initialize window
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
    love.keyboard.keysPressed = {}
    gStateMachine = StateMachine {
        ['play'] = function() return PlayState() end,
        ['title'] = function() return TitleScreenState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title')
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
    gStateMachine:update(dt)
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
    -- draw the ground on top of the background, toward the bottom of the screen
    love.graphics.draw(ground, -backgroundScroll, VIRTUAL_HEIGHT - 16)
    gStateMachine:render()
    push.finish()
end

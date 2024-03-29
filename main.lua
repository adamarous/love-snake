require 'entities'

-- Global variables
local player = Player(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 100, 50)
local consumables = {yellow = Consumable('yellow'), red = Consumable('red')}
-- Game state
local gameStarted = false
-- Initialize game
local gameOver = false
-- Define a minimum distance between the consumables
local minimumDistance = 100

-- Set initial position of consumables
local function setInitialPosition(consumable)
    repeat
        consumable.x = math.random(love.graphics.getWidth() - consumable.size)
        consumable.y = math.random(love.graphics.getHeight() - consumable.size)
    until math.sqrt((consumable.x + consumable.size/2 - player.x - player.size/2)^2 + (consumable.y + consumable.size/2 - player.y - player.size/2)^2) > minimumDistance
end

function love.load()
    -- Set initial position of player
    player.x = love.graphics.getWidth() / 2
    player.y = love.graphics.getHeight() / 2

    -- Create a random seed for the random number generator
    math.randomseed(os.time())

    -- Set initial consumable positions
    setInitialPosition(consumables.yellow)
    setInitialPosition(consumables.red)
end

-- Define an accumulator for the elapsed time
local accumulator = 0

function love.update(dt)
    -- Accumulate the elapsed time
    accumulator = accumulator + dt

    -- Start game on arrow key press
    if love.keyboard.isDown('up', 'down', 'left', 'right') then
        if not gameStarted then
            gameStarted = true
            accumulator = 0 -- Reset accumulator when game starts
        end
    end

    -- Update player position based on speed and direction
    if gameStarted and not gameOver then
        -- Calculate the amount of movement
        local movement = player.speed * accumulator

        -- Update the player's position
        if love.keyboard.isDown('up') then
            player.y = player.y - movement
        elseif love.keyboard.isDown('down') then
            player.y = player.y + movement
        elseif love.keyboard.isDown('left') then
            player.x = player.x - movement
        elseif love.keyboard.isDown('right') then
            player.x = player.x + movement
        end

        -- Reset the accumulator
        accumulator = 0

        -- Check for collision with consumables and increase speed
        for _, consumable in pairs(consumables) do
            if player.x < consumable.x + consumable.size and
               player.x + player.size > consumable.x and
               player.y < consumable.y + consumable.size and
               player.y + player.size > consumable.y then
                player.speed = player.speed + consumable.speedIncrease

                -- Move consumable to new random location
                repeat
                    consumable.x = math.random(love.graphics.getWidth() - consumable.size)
                    consumable.y = math.random(love.graphics.getHeight() - consumable.size)
                until math.sqrt((consumables.yellow.x + consumables.yellow.size/2 - consumables.red.x - consumables.red.size/2)^2 + (consumables.yellow.y + consumables.yellow.size/2 - consumables.red.y - consumables.red.size/2)^2) > minimumDistance
            end
        end

        -- Check for game over condition
        if player.x < 0 or player.y < 0 or player.x + player.size > love.graphics.getWidth() or player.y + player.size > love.graphics.getHeight() then
            gameOver = true
        end
    end
end

function love.draw()
    -- Draw player
    love.graphics.rectangle('fill', player.x, player.y, player.size, player.size)

    -- Draw consumables
    for color, consumable in pairs(consumables) do
        love.graphics.setColor(color == 'yellow' and {1, 1, 0} or {1, 0, 0})
        love.graphics.rectangle('fill', consumable.x, consumable.y, consumable.size, consumable.size)
    end

    -- Reset color
    love.graphics.setColor(1, 1, 1)

    -- Display game over message
    if gameOver then
        local gameOverText = 'Game Over'
        local textWidth = love.graphics.getFont():getWidth(gameOverText)
        local textHeight = love.graphics.getFont():getHeight()

        -- Enable anti-aliasing for crisp text rendering
        local font = love.graphics.getFont()
        font:setFilter("nearest", "nearest")

        love.graphics.print(gameOverText, love.graphics.getWidth() / 2 - textWidth / 2, love.graphics.getHeight() / 2 - textHeight / 2)
    end
end
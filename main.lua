-- Global variables
local player
local consumables
-- Game state
local gameStarted = false
-- Initialize game
local gameOver = false

function love.load()
    -- Player
    player = {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        speed = 100,
        size = 50
    }

    -- Consumables
    consumables = {
        yellow = {
            x = math.random(love.graphics.getWidth() - 50), -- Subtract the size of the consumable from the width
            y = math.random(love.graphics.getHeight() - 50), -- Subtract the size of the consumable from the height
            speedIncrease = 50,
            size = 50
        },
        red = {
            x = math.random(love.graphics.getWidth() - 75), -- Subtract the size of the consumable from the width
            y = math.random(love.graphics.getHeight() - 75), -- Subtract the size of the consumable from the height
            speedIncrease = 100,
            size = 75
        }
    }
end

-- Define a fixed time step
local fixedDt = 1 / 60 -- 60 updates per second

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
                consumable.x = math.random(love.graphics.getWidth())
                consumable.y = math.random(love.graphics.getHeight())
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
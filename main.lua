-- Player
local player = {
    x = love.graphics.getWidth() / 2,
    y = love.graphics.getHeight() / 2,
    speed = 50,
    size = 10
}

-- Consumables
local consumables = {
    yellow = {
        x = math.random(love.graphics.getWidth()),
        y = math.random(love.graphics.getHeight()),
        speedIncrease = 1,
        size = 10
    },
    red = {
        x = math.random(love.graphics.getWidth()),
        y = math.random(love.graphics.getHeight()),
        speedIncrease = 5,
        size = 10
    }
}

-- Game state
local gameStarted = false

function love.load()
    -- Initialize game
    gameOver = false
    player.speed = 50 -- Set initial speed
end

function love.update(dt)
    -- Start game on arrow key press
    if love.keyboard.isDown('up', 'down', 'left', 'right') then
        gameStarted = true
    end

    -- Update player position based on speed and direction
    if gameStarted and not gameOver then
        if love.keyboard.isDown('up') then
            player.y = player.y - player.speed * dt
        elseif love.keyboard.isDown('down') then
            player.y = player.y + player.speed * dt
        elseif love.keyboard.isDown('left') then
            player.x = player.x - player.speed * dt
        elseif love.keyboard.isDown('right') then
            player.x = player.x + player.speed * dt
        end

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
        if player.x < 0 or player.y < 0 or player.x > love.graphics.getWidth() or player.y > love.graphics.getHeight() then
            gameOver = true
        end
    end
end

function love.draw()
    -- Draw player
    love.graphics.rectangle('fill', player.x, player.y, 10, 10)

    -- Draw consumables
    for color, consumable in pairs(consumables) do
        love.graphics.setColor(color == 'yellow' and {1, 1, 0} or {1, 0, 0})
        love.graphics.rectangle('fill', consumable.x, consumable.y, 10, 10)
    end

    -- Reset color
    love.graphics.setColor(1, 1, 1)

    -- Display game over message
    if gameOver then
        local gameOverText = 'Game Over'
        local textWidth = love.graphics.getFont():getWidth(gameOverText)
        local textHeight = love.graphics.getFont():getHeight()

        love.graphics.print(gameOverText, love.graphics.getWidth() / 2 - textWidth / 2, love.graphics.getHeight() / 2 - textHeight / 2)
    end
end
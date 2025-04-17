local menu = require("menu")
local gameState = require("modules.gameState")
local ballManager = require("modules.ballManager")
local cueManager = require("modules.cueManager")
local tableManager = require("modules.tableManager")

function love.load()
    menu.load()
    gameState.load()
    ballManager.load()
    cueManager.load(gameState, ballManager)
    tableManager.load()
end

function love.update(dt)
    if gameState.isGameOver() then return end
    
    if gameState.isGameActive() then
        ballManager.update(dt)
        cueManager.update(dt)
    else
        menu.update(dt)
    end
end

function love.draw()
    if gameState.isGameOver() then
        drawGameOverScreen()
    elseif gameState.isGameActive() then
        tableManager.draw()
        ballManager.draw()
        cueManager.draw()
        drawScore()
    else
        menu.draw()
    end
end

function love.mousepressed(x, y, button)
    if gameState.isGameOver() then
        handleGameOverClick(x, y)
    elseif gameState.isGameActive() then
        cueManager.handleMousePress(x, y, button)
    else
        menu.mousepressed(x, y)
    end
end

function love.mousereleased(x, y, button)
    if gameState.isGameActive() then
        cueManager.handleMouseRelease(x, y, button)
    end
end

-- Funções auxiliares locais
function drawScore()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Pontuação: " .. gameState.getScore(), 10, 10)
end

function drawGameOverScreen()
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(gameState.getGameOverMessage(), 0, love.graphics.getHeight() / 2 - 50, 
                        love.graphics.getWidth(), "center")

    love.graphics.setColor(0.2, 0.8, 0.2)
    love.graphics.rectangle("fill", love.graphics.getWidth() / 2 - 100, 
                           love.graphics.getHeight() / 2, 200, 50)

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Jogar", 0, love.graphics.getHeight() / 2 + 15, 
                        love.graphics.getWidth(), "center")
end

function handleGameOverClick(x, y)
    local buttonX = love.graphics.getWidth() / 2 - 100
    local buttonY = love.graphics.getHeight() / 2
    local buttonWidth = 200
    local buttonHeight = 50

    if x > buttonX and x < buttonX + buttonWidth and 
       y > buttonY and y < buttonY + buttonHeight then
        gameState.resetGame()
        menu.load()
    end
end
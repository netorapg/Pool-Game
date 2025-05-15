local menu = {
    buttons = {},
    font = nil,
    instructionsActive = false,
    gameState = nil,
    ballManager = nil,
    tableDimensions = {x=0, y=0, w=0, h=0}
}

function menu.load(gs, bm, x, y, w, h)
    menu.gameState = gs
    menu.ballManager = bm
    menu.tableDimensions = {x=x, y=y, w=w, h=h}
    
    print("Carregando menu...")
    menu.font = love.graphics.newFont(30)

    menu.buttons = {
    {
        text = "Novo Jogo",
        x = 300,
        y = 200,
        width = 200,
        height = 50,
        action = function()
            menu.gameState.startGame()
            menu.ballManager.setupBalls(
                menu.tableDimensions.x,
                menu.tableDimensions.y,
                menu.tableDimensions.w,
                menu.tableDimensions.h
            )
            menu.instructionsActive = false
        end
    },
    {
        text = "Instruções",
        x = 300,
        y = 300,
        width = 200,
        height = 50,
        action = function()
            menu.instructionsActive = not menu.instructionsActive
        end
    },
    }
end

function menu.update(dt)
    
end

function menu.draw()
    love.graphics.setColor(0.1, 0.1, 0.2)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setFont(menu.font)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Cool Snoker", 0, 100, love.graphics.getWidth(), "center")

    for _, button in ipairs(menu.buttons) do
        love.graphics.setColor(0.2, 0.6, 0.2)
        love.graphics.rectangle("fill", button.x, button.y, button.width, button.height, 5, 5)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(button.text, button.x, button.y + 15, button.width, "center")
    end

    if menu.instructionsActive then
        drawInstructions()
    end
end

function menu.mousepressed(x, y)
    if menu.instructionsActive then
        menu.instructionsActive = false
        return
    end

    for _, button in ipairs(menu.buttons) do
        if x >= button.x and x <= button.x + button.width and
            y >= button.y and y <= button.y + button.height then
            button.action()
            return
        end
    end
end

function drawInstructions()
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 100, 100, 600, 400)

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Instruções do Jogo", 100, 120, 600, "center")

    local instructionsText = {
        "1. Use o mouse para mirar na bola branca",
        "2. Clique e arraste para definir a direção e força",
        "3. Solte o botão do mouse para dar a tacada",
        "4. Encaçape as bolas para pontuar",
        "5. Cuidado com a bola 8",
        "",
        "Clique em qualquer lugar para voltar"
    }

    for i, line in ipairs(instructionsText) do
        love.graphics.printf(line, 120, 160 + (i-1)*30, 560, "left")
    end
end

return menu

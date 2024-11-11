-- main.lua
local menu = require("menu")
local gameActive = false  -- Variável para controlar se o jogo está ativo

function love.load()
    menu.load()
end

function love.update(dt)
    if gameActive then
        -- Atualizar lógica do jogo aqui (física da mesa, etc.)
    else
        menu.update(dt)
    end
end

function love.draw()
    if gameActive then
        drawTable()  -- Desenhar a mesa de sinuca
    else
        menu.draw()
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if gameActive then
        -- Processar eventos do jogo ativo aqui
    else
        menu.mousepressed(x, y)
    end
end

-- Função para iniciar o jogo
function startGame()
    gameActive = true
end

-- Função para desenhar a mesa de sinuca
function drawTable()
    local tableWidth, tableHeight = 600, 300
    local tableX, tableY = (love.graphics.getWidth() - tableWidth) / 2, (love.graphics.getHeight() - tableHeight) / 2
    local borderWidth = 20
    local holeRadius = 15

    -- Fundo da mesa
    love.graphics.setColor(0, 0.5, 0)  -- Cor verde
    love.graphics.rectangle("fill", tableX, tableY, tableWidth, tableHeight)

    -- Bordas da mesa
    love.graphics.setColor(0.5, 0.25, 0)  -- Cor marrom para as bordas
    love.graphics.rectangle("fill", tableX - borderWidth, tableY, borderWidth, tableHeight)  -- Esquerda
    love.graphics.rectangle("fill", tableX + tableWidth, tableY, borderWidth, tableHeight)   -- Direita
    love.graphics.rectangle("fill", tableX - borderWidth, tableY - borderWidth, tableWidth + borderWidth * 2, borderWidth) -- Topo
    love.graphics.rectangle("fill", tableX - borderWidth, tableY + tableHeight, tableWidth + borderWidth * 2, borderWidth) -- Base

    -- Buracos da mesa (nos cantos e no centro das laterais)
    love.graphics.setColor(0, 0, 0)  -- Cor preta para os buracos
    local holes = {
        {x = tableX, y = tableY},  -- Canto superior esquerdo
        {x = tableX + tableWidth / 2, y = tableY},  -- Meio superior
        {x = tableX + tableWidth, y = tableY},  -- Canto superior direito
        {x = tableX, y = tableY + tableHeight},  -- Canto inferior esquerdo
        {x = tableX + tableWidth / 2, y = tableY + tableHeight},  -- Meio inferior
        {x = tableX + tableWidth, y = tableY + tableHeight}  -- Canto inferior direito
    }
    for _, hole in ipairs(holes) do
        love.graphics.circle("fill", hole.x, hole.y, holeRadius)
    end
end

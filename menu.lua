-- menu.lua
local menu = {}

local buttons = {}
local font

function menu.load()
    -- Carregar fonte
    font = love.graphics.newFont(30)

    -- Definir os botões do menu
    buttons = {
        {text = "Novo Jogo", x = 300, y = 200, width = 200, height = 50, action = startGame},
        {text = "Instruções", x = 300, y = 300, width = 200, height = 50, action = showInstructions},
    }
end

function menu.update(dt)
    -- Atualizar qualquer lógica se necessário
end

function menu.draw()
    -- Desenhar fundo e título
    love.graphics.setFont(font)
    love.graphics.printf("Jogo de Sinuca", 0, 100, love.graphics.getWidth(), "center")

    -- Desenhar botões
    for _, button in ipairs(buttons) do
        love.graphics.setColor(0.2, 0.6, 0.2)  -- Cor verde para o botão
        love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)
        love.graphics.setColor(1, 1, 1)  -- Cor branca para o texto
        love.graphics.printf(button.text, button.x, button.y + 15, button.width, "center")
    end
end


function menu.mousepressed(x, y)
    -- Verificar se algum botão foi clicado
    for _, button in ipairs(buttons) do
        if x >= button.x and x <= button.x + button.width and y >= button.y and y <= button.y + button.height then
            button.action()
        end
    end
end

-- Funções de ação para os botões
function startGame()
    print("Iniciando o novo jogo...")
    -- Aqui podemos colocar o código para iniciar o jogo
end

function showInstructions()
    print("Mostrando as instruções...")
    -- Aqui podemos colocar o código para exibir as instruções
end

return menu
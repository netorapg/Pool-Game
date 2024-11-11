--main.lua
local menu = require("menu")

function love.load()
    -- Carreagr a tela inicial
    menu.load()
end

function love.update(dt)
    -- Atualizar a tela inicial
    menu.update(dt)
end

function love.draw()
    -- Desenhar a tela inicial
    menu.draw()
end

function love.mousepressed(x, y, button, istouch, presses)
    -- Detectar clique do mouse
    menu.mousepressed(x, y)
end
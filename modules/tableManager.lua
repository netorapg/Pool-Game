local tableManager = {
    width = 600,
    height = 300,
    x = 0,
    y = 0
}

function tableManager.initialize()
    tableManager.x = (love.graphics.getWidth() - tableManager.width) / 2
    tableManager.y = (love.graphics.getHeight() - tableManager.height) / 2
end

function tableManager.drawTable()

end

return tableManager
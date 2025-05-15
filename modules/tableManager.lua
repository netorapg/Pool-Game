local tableManager = {
    width = 600,
    height = 300,
    x = 0,
    y = 0,
    borderWidth = 20,
    holeRadius = 15
}

function tableManager.initialize()
    tableManager.x = (love.graphics.getWidth() - tableManager.width) / 2
    tableManager.y = (love.graphics.getHeight() - tableManager.height) / 2
end

function tableManager.draw()
    love.graphics.setColor(0,0.5, 0)
    love.graphics.rectangle("fill", tableManager.x, tableManager.y, tableManager.width, tableManager.height)

    love.graphics.setColor(0.5, 0.25, 0)
    drawTableBorders()

    love.graphics.setColor(0, 0, 0)
end

function drawTableBorders()
    -- Bordas laterais
    love.graphics.rectangle("fill", tableManager.x - tableManager.borderWidth, tableManager.y, tableManager.borderWidth, tableManager.height)
    love.graphics.rectangle("fill", tableManager.x + tableManager.width, tableManager.y, tableManager.borderWidth, tableManager.height)

    --Bordas superior e inferior
    love.graphics.rectangle("fill", tableManager.x - tableManager.borderWidth, tableManager.y - tableManager.borderWidth, tableManager.width + tableManager.borderWidth * 2, tableManager.borderWidth)
    love.graphics.rectangle("fill", tableManager.x - tableManager.borderWidth, tableManager.y + tableManager.height, tableManager.width + tableManager.borderWidth * 2, tableManager.borderWidth)
end


function drawTableHoles()
    local holes = {
        {x = tableManager.x, y = tableManager.y},
        {x = tableManager.x + tableManager.width / 2, y = tableManager.y},
        {x = tableManager.x + tableManager.width, y = tableManager.y},
        {x = tableManager.x + tableManager.width / 2, y = tableManager.y + tableManager.height},
        {x = tableManager.x + tableManager.width, y = tableManager.y + tableManager.height}
    }

    for _, hole in ipairs(holes) do
        love.graphics.circle("fill", hole.x, hole.y, tableManager.holeRadius)
    end
end

function tableManager.getDimensions()
    return tableManager.x, tableManager.y, tableManager.width, tableManager.height
end

return tableManager

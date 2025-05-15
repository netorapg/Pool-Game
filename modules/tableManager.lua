-- modules/tableManager.lua

local tableManager = {
    width = 600,
    height = 300,
    x = 0,
    y = 0,
    borderWidth = 20,
    holeRadius = 15
}

function tableManager.initialize()
    tableManager.x = (love.graphics.getWidth()  - tableManager.width)  / 2
    tableManager.y = (love.graphics.getHeight() - tableManager.height) / 2
end

function tableManager.draw()
    -- Cor do pano
    love.graphics.setColor(0, 0.5, 0)
    love.graphics.rectangle("fill", tableManager.x, tableManager.y, tableManager.width, tableManager.height)

    -- Cor das bordas
    love.graphics.setColor(0.5, 0.25, 0)
    drawTableBorders()

    -- Cor e desenho dos buracos
    love.graphics.setColor(0, 0, 0)
    drawTableHoles()
end

-- Desenha as bordas da mesa
function drawTableBorders()
    -- Laterais
    love.graphics.rectangle("fill",
        tableManager.x - tableManager.borderWidth, tableManager.y,
        tableManager.borderWidth, tableManager.height
    )
    love.graphics.rectangle("fill",
        tableManager.x + tableManager.width, tableManager.y,
        tableManager.borderWidth, tableManager.height
    )
    -- Topo e fundo
    love.graphics.rectangle("fill",
        tableManager.x - tableManager.borderWidth,
        tableManager.y - tableManager.borderWidth,
        tableManager.width + tableManager.borderWidth * 2,
        tableManager.borderWidth
    )
    love.graphics.rectangle("fill",
        tableManager.x - tableManager.borderWidth,
        tableManager.y + tableManager.height,
        tableManager.width + tableManager.borderWidth * 2,
        tableManager.borderWidth
    )
end

-- Desenha todos os 6 buracos
function drawTableHoles()
    local x, y, w, h = tableManager.x, tableManager.y, tableManager.width, tableManager.height
    local r = tableManager.holeRadius

    local holes = {
        { x = x,         y = y         },  -- canto superior esquerdo
        { x = x + w/2,   y = y         },  -- meio superior
        { x = x + w,     y = y         },  -- canto superior direito
        { x = x,         y = y + h     },  -- canto inferior esquerdo
        { x = x + w/2,   y = y + h     },  -- meio inferior
        { x = x + w,     y = y + h     }   -- canto inferior direito
    }

    for _, hole in ipairs(holes) do
        love.graphics.circle("fill", hole.x, hole.y, r)
    end
end

function tableManager.getDimensions()
    return tableManager.x, tableManager.y, tableManager.width, tableManager.height
end

return tableManager

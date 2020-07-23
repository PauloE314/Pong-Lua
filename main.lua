--[[
    Arquivo principal para o jogo PONG, programado em LUA com o framework LOVE 2D
]]

-- Configurações da aplicação
settings = require("settings")
-- Importação de libs
push = require("libs/push")

-- Função de setup da aplicação
function love.load()
    -- Seta o modo da aplicação (tela) com aspecto antigo
    push:setupScreen(
        settings.width.virtual,
        settings.height.virtual,
        settings.width.real,
        settings.height.real,
        {
            fullscreen = false,
            vsync = true,
            resizable = false
        }
    )
end

-- Função de update de frames
function love.update()

end

-- Função de renderização
function love.draw()
    push:apply('start')

    love.graphics.printf("Hello World", 0, settings.height.virtual / 2, settings.width.virtual, 'center')
    

    push:apply('end')
end
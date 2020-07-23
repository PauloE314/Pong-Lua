--[[
    Arquivo principal para o jogo PONG, programado em LUA com o framework LOVE 2D
]]

-- Configurações da aplicação
settings = require("settings")
-- Importação de libs
Class = require("libs/class")
push = require("libs/push")
-- Importação de entidades
require "entities/paddle"
require "entities/ball"


-- Dimensões
real = settings.screen.real
virtual = settings.screen.virtual
paddles = settings.paddles

-- Estado do jogo
STATE = 'start'

-- Função de setup da aplicação
function love.load()
    -- Faz as arestas não ficarem arredondadas
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Seta o nome da aplicação na caixa da janela
    love.window.setTitle('Pong')

    -- Configuração de fontes
    small_font = love.graphics.setNewFont('resources/font - 8 bits.TTF', 8)

    -- Texto de título
    title = 'Hello Pong!'

    -- Seta o modo da aplicação (tela) com aspecto antigo
    push:setupScreen(
        virtual.width,
        virtual.height,
        real.width,
        real.height,
        {
            fullscreen = false,
            vsync = true,
            resizable = false
        }
    )

    -- Cria os dois paddles
    paddle_1 = Paddle({
        x = 5,
        y = 20,
        width = paddles.width,
        height = paddles.height,
        up_key = 'up',
        down_key = 'down'
    })
    -- Cria paddle 2 em uma posição diferente e controles diferentes
    paddle_2 = Paddle({
        x = virtual.width - 10,
        y = virtual.height - 30,
        width = paddles.width,
        height = paddles.height,
        up_key = 'w',
        down_key = 's'
    })

    -- Cria bolinha
    ball = Ball({
        x = virtual.width / 2 - 2,
        y = virtual.height / 2 - 2,
        width = settings.ball.width,
        height = settings.ball.height,
    })
end

-- Função de update de frames
function love.update(dt)
    
    -- Atualiza os paddles
    paddle_1:update(dt, virtual.height)
    paddle_2:update(dt, virtual.height)
    
    -- Checa os controles de cada um
    paddle_1:controls(virtual.height)
    paddle_2:controls(virtual.height)
    
    -- Atualiza a bolinha
    if STATE == 'playing' then
        ball:update(dt)
    end
end

-- Função que lida com teclas apertadas
function love.keypressed(key)
    -- Reposiciona a bolinha
    if key == 'enter' or key == 'return' then
        ball:reset(virtual.width, virtual.height)
        -- Alterna o estado do jogo
        if STATE == 'start' then
            STATE = 'playing'
            title = 'Play!'

        elseif STATE == 'playing' then
            STATE = 'start'
            title = 'Hello Pong!'
        end
    end
end


-- Função de renderização
function love.draw()
    -- Inicia a renderização retro
    push:apply('start')

    -- Limpa a tela
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

    -- Renderiza O texto superior
    love.graphics.setFont(small_font)
    love.graphics.printf(title, 0, 20, virtual.width, 'center')

    -- Renderiza bola
    ball:render()

    -- Renderiza paddles
    paddle_1:render()
    paddle_2:render()
    
    -- Fecha a renderização retro
    push:apply('end')
end
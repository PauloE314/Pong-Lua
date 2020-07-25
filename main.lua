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
states = settings.states
winning_points = settings.win_points

-- Função de setup da aplicação
function love.load()
    -- Seed
    math.randomseed(os.time())
    
    -- Faz as arestas não ficarem arredondadas
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Seta o nome da aplicação na caixa da janela
    love.window.setTitle('Pong')

    -- Configuração de fontes
    small_font = love.graphics.setNewFont('resources/font - 8 bits.TTF', 8)
    medium_font = love.graphics.setNewFont('resources/font - 8 bits.TTF', 16)
    big_font = love.graphics.setNewFont('resources/font - 8 bits.TTF', 24)
    large_font = love.graphics.setNewFont('resources/font - 8 bits.TTF', 32)

    -- Armazena o turno do jogador
    turn = nil
    -- Armazena vencedor
    winner = nil

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

    -- Seta o estado inicial do jogo
    game_state = states.begin
end

-- Função de update de frames
function love.update(dt)
    
    -- Atualiza os paddles
    paddle_1:update(dt, virtual.height)
    paddle_2:update(dt, virtual.height)
    
    -- Checa os controles de cada um
    paddle_1:controls(virtual.height)
    paddle_2:controls(virtual.height)


    -- Checa se o jogo ainda está valendo
    if paddle_1.points >= winning_points then
        game_state = states.win
        winner = '1'

    elseif paddle_2.points >= winning_points then
        game_state = states.win
        winner = '2'
    end
    
    -- Lógica de funcionamento da bolinha
    if game_state == states.playing then
        -- Paddle 1
        if ball:collide_object(paddle_1) then
            ball:invert_x()
            ball.x = paddle_1.x + paddle_1.width 

        -- Paddle 2
        elseif ball:collide_object(paddle_2) then
            ball:invert_x()
            ball.x = paddle_2.x - (paddle_2.width + ball.width)
        end

        
        -- Colisão com paredes
        -- Borda superior
        if ball.y <= 0 then
            ball:invert_y()
            ball.y = 0
        -- Borda inferior
        elseif ball.y + ball.height > virtual.height then
            ball:invert_y()
            ball.y = virtual.height - ball.height
        end


        -- Lida com pontuação
        if ball.x <= 0 then
            turn = '2'
            -- Restart
            game_state = states.serve
            ball:reset(virtual.width, virtual.height, turn)
            -- Adiciona a pontuação do jogador 2
            paddle_2:increase_point()
        elseif ball.x + ball.width >= virtual.width then
            turn = '1'
            -- Restart
            game_state = states.serve
            ball:reset(virtual.width, virtual.height, turn)
            -- Adiciona a pontuação do jogador 1
            paddle_1:increase_point()
        end
        
        ball:update(dt)
    end
end

-- Função que lida com teclas apertadas
function love.keypressed(key)
    -- Reposiciona a bolinha
    if key == 'enter' or key == 'return' then
        if game_state == states.serve or game_state == states.begin then
            game_state = states.playing
        -- Reinicia o jogo
        elseif game_state == states.win then
            game_state = states.begin
            paddle_1.points = 0
            paddle_2.points = 0
            ball:reset(virtual.width, virtual.height)
        end
    end
end


-- Função de renderização
function love.draw()
    -- Inicia a renderização retro
    push:apply('start')

    -- Limpa a tela
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

    -- Renderiza o texto superior
    -- Mensagem de início
    if game_state == states.begin then
        love.graphics.setFont(medium_font)
        love.graphics.printf("Hello Pong!", 0, 20, virtual.width, 'center')
    -- Mensagem de 'serve'
    elseif game_state == states.serve then 
        love.graphics.setFont(medium_font)
        love.graphics.printf("Vez do jogador " .. turn .. "!", 0, 20, virtual.width, 'center')

        love.graphics.setFont(small_font)
        love.graphics.printf("Aperte [enter] para continuar", 0, 40, virtual.width, 'center')
    -- Mensagem de vitória
    elseif game_state == states.win then
        love.graphics.setFont(big_font)
        love.graphics.printf("O jogador " .. winner .. " ganhou!", 0, 20, virtual.width, 'center')

        love.graphics.setFont(small_font)
        love.graphics.printf("Aperte [enter] para reiniciar", 0, 50, virtual.width, 'center')
    end

    -- Renderiza a pontuação
    love.graphics.setFont(large_font)

    -- Pontuação do player 1
    love.graphics.printf(tostring(paddle_1.points), -40, virtual.height / 2 - 50, virtual.width, 'center')
    -- Pontuação do player 2
    love.graphics.printf(tostring(paddle_2.points), 40, virtual.height / 2 - 50, virtual.width, 'center')

    -- Renderiza bola
    ball:render()

    -- Renderiza paddles
    paddle_1:render()
    paddle_2:render()
    
    -- Fecha a renderização retro
    push:apply('end')
end
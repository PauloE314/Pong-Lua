-- Classe base para a bolinha do pong
Ball = Class{}


-- Inicialização
function Ball:init(data)
    self.x = data.x
    self.y = data.y
    self.width = data.width
    self.height = data.height
    -- Gera a velocidade inicial da bolinha aleatoriamente
    -- self.x_speed = math.random(2) == 1 and 100 or -100
    self.x_speed = -100
    self.y_speed = math.random(50, -50)
end

-- Reinicia a posição da bolinha
function Ball:reset(windows_width, windows_height, player_turn)
    self.x = windows_width / 2 - self.width / 2
    self.y = windows_height / 2 - self.height / 2

    -- Caso haja um turno, redireciona a bola para aquela direção
    if player_turn ~= nil then
        if player_turn == '1' then
            self.x_speed = -100
        else
            self.x_speed = 100
        end
    -- Caso não haja, seta uma direção aleatória
    else
        self.x_speed = math.random(2) == 1 and 100 or -100
    end
end

-- Atualiza o estado do objecto
function Ball:update(dt)
    local new_x = self.x + self.x_speed * dt
    local new_y = self.y + self.y_speed * dt

    -- Atualiza a posição da bolinha
    self.x = self.x_speed < 0 and math.floor(new_x) or math.ceil(new_x)
    self.y = self.y_speed < 0 and math.floor(new_y) or math.ceil(new_y)
end

-- Checa a colisão da bolinha com um objeto
function Ball:collide_object(rect)
    -- Colisão horizontal
    if self.x > rect.x + rect.width or self.x + self.width < rect.x then
        return false
    end
    -- Colisão vertical
    if self.y > rect.y + rect.height or self.y + self.height < rect.y then
        return false
    end

    return true
end


-- Inverte o eixo x da bolinha
function Ball:invert_x()
   self.x_speed = -self.x_speed 
end

-- Inverte o eixo y da bolinha
function Ball:invert_y()
    self.y_speed = -self.y_speed
end


-- Renderiza a bolinha em tela
function Ball:render()
    love.graphics.rectangle(
        'fill',
        self.x,
        self.y,
        self.width,
        self.height
    )
end

-- Classe base para os paddles do pong
Paddle = Class{}

-- Inicialização
function Paddle:init(data)
    self.x = data.x
    self.y = data.y
    self.width = data.width
    self.height = data.height
    self.up_key = data.up_key
    self.down_key = data.down_key

    self.y_speed = 0
end

-- Atualiza o estado do objecto
function Paddle:update(dt, windows_height)
    -- Descer
    if self.y_speed < 0 then
        self.y = math.max(0, self.y + self.y_speed * dt)
    -- Subir
    elseif self.y_speed > 0 then
        self.y = math.min(windows_height - 20, self.y + self.y_speed * dt)
    end
end

-- Lida com possíveis eventos do teclado
function Paddle:controls(speed)
    -- Sobe
    if love.keyboard.isDown(self.up_key) then
        self.y_speed = -speed
    -- Desce
    elseif love.keyboard.isDown(self.down_key) then
        self.y_speed = speed
    -- Para
    else
        self.y_speed = 0
    end
end

-- Renderiza o paddle em tela
function Paddle:render()
    love.graphics.rectangle(
        'fill',
        self.x,
        self.y,
        self.width,
        self.height
    )
end

-- Classe base para a bolinha do pong
Ball = Class{}


-- Inicialização
function Ball:init(data)
    self.x = data.x
    self.y = data.y
    self.width = data.width
    self.height = data.height
    -- Gera a velocidade inicial da bolinha aleatoriamente
    self.x_speed = math.random(2) == 1 and 100 or -100
    self.y_speed = math.random(50, -50)
end

-- Reinicia a posição da bolinha
function Ball:reset(windows_width, windows_height)
    self.x = windows_width / 2 - self.width / 2
    self.y = windows_height / 2 - self.height / 2
end

-- Atualiza o estado do objecto
function Ball:update(dt, windows_height)
    -- Atualiza a posição da bolinha
    self.x = self.x + self.x_speed * dt
    self.y = self.y + self.y_speed * dt
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

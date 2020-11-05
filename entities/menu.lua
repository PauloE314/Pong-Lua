-- Classe base para os paddles do pong
Menu = Class{}

-- Inicialização
function Menu:init(data)
    self.current_item = 0
    self.up_key = data.up_key
    self.down_key = data.down_key
    
end


-- Lida com possíveis eventos do teclado
function Menu:controls(speed)
    -- Sobe
    if love.keyboard.isDown(self.up_key) then
        self.current_item = math.max(0, self.current_item - 1)
    -- Desce
    elseif love.keyboard.isDown(self.down_key) then
        self.current_item = math.min(1, self.current_item + 1)
    end
end

-- Renderiza o paddle em tela
function Menu:render()
    love.graphics.setFont(small_font)    

    -- Seta caso 1
    if self.current_item == 0 then
        colors.setWhite()
        love.graphics.printf("1 Jogador", 0, virtual.height/2 - 10, virtual.width, 'center')
        colors.setGray()
        love.graphics.printf("2 Jogadores", 0, virtual.height/2 + 10, virtual.width, 'center')

    -- Seta caso 2
    else
        colors.setGray()
        love.graphics.printf("1 Jogador", 0, virtual.height/2 - 10, virtual.width, 'center')
        colors.setWhite()
        love.graphics.printf("2 Jogadores", 0, virtual.height/2 + 10, virtual.width, 'center')
    end
end

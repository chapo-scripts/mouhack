local airbrake = { speed = 2 }
function airbrake:getAngle(speed)
    return {speed * math.sin(-math.rad(getCharHeading(PLAYER_PED) - 90)), speed * math.cos(-math.rad(getCharHeading(PLAYER_PED) - 90))}
end
function airbrake:process()
    if (not self.p) then
        local x, y, z = getCharCoordinates(PLAYER_PED)
        self.p = { x = x, y = y, z = z }
    end
    if not sampIsCursorActive() then
        -- SPEED EDITOR
        local speedEdit = getMousewheelDelta()
        if speedEdit ~= 0 then
            if self.speed >= 0 then
                self.speed = self.speed + speedEdit / 10
                printStringNow('~y~AIRBRAKE: ~w~Speed = ~p~'..self.speed, 200)
            end
        end
        if self.speed < 0 then self.speed = 0 end
        -- SET MOUSE HEADING
        local cx, cy, _ = getActiveCameraCoordinates()
        local px, py, _ = getActiveCameraPointAt()
        local camDirection = math.atan2( (px-cx), (py-cy) ) * 180 / math.pi
        if isCharInAnyCar(PLAYER_PED) then
            setCarHeading(storeCarCharIsInNoSave(PLAYER_PED), - camDirection)
        else
            setCharHeading(PLAYER_PED, - camDirection)
        end
        
        
        -- CONTROLS
        if isKeyDown(VK_SPACE) then self.p.z = self.p.z + self.speed / 2  end
        if isKeyDown(VK_LSHIFT) and self.p.z > -95.0 then self.p.z = self.p.z - self.speed / 2 end
        if isKeyDown(VK_W) then 
            self.p.x = self.p.x + self.speed * math.sin(-math.rad(getCharHeading(PLAYER_PED))) 
            self.p.y = self.p.y + self.speed * math.cos(-math.rad(getCharHeading(PLAYER_PED))) 
        end
        if isKeyDown(VK_S) then 
            self.p.x = self.p.x - self.speed * math.sin(-math.rad(getCharHeading(PLAYER_PED))) 
            self.p.y = self.p.y - self.speed * math.cos(-math.rad(getCharHeading(PLAYER_PED))) 
        end
        if isKeyDown(VK_A) then 
            self.p.x = self.p.x - self:getAngle(self.speed)[1] 
            self.p.y = self.p.y - self:getAngle(self.speed)[2] 
        end
        if isKeyDown(VK_D) then 
            self.p.x = self.p.x + self:getAngle(self.speed)[1]  
            self.p.y = self.p.y + self:getAngle(self.speed)[2]  
        end
    end
    setCharCoordinates(PLAYER_PED, self.p.x, self.p.y, self.p.z)
end


return function(page)
    page.config.airbrake = imgui.new.bool(false)
    page.config.airbrakeSpeed = imgui.new.float(2)
    page.config.airbrakeMouseSpeedControl = imgui.new.bool(true)

    page:On("loop", function()
        if(page.config.airbrake[0]) then
            airbrake:process()
        end
    end)

    return Funcs:new(FuncType.Toggle, {
        label = "AirBrake",
        unsafe = Const.UNSAFE_ITEM_LABEL_GRANTED_KICK,
        value = page.config.airbrake,
        options = {
            Funcs:new(FuncType.Toggle, {
                label = "Изменять скорость колесиком мыши",
                value = page.config.airbrakeMouseSpeedControl,
                isOption = true
            }),
            Funcs:new(FuncType.SliderFloat, {
                label = "Скорость",
                value = page.config.airbrakeSpeed,
                min = 0.1,
                max = 25,
                isOption = true
            })
        }
    })
end
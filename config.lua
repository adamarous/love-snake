function love.conf(t)
    t.window.title = "Snake Game"
    t.modules.audio = false
    t.modules.event = false
    t.modules.graphics = true -- Keep graphics module
    t.modules.image = false
    t.modules.joystick = false
    t.modules.keyboard = true -- Keep keyboard module
    t.modules.math = false
    t.modules.mouse = false
    t.modules.physics = false
    t.modules.sound = false
    t.modules.system = false
    t.modules.timer = true -- Keep timer module
    t.modules.touch = false
    t.modules.video = false
    t.modules.window = true -- Keep window module
end

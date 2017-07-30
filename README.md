# Introducing the Humble_rpi-plugin-led

    require 'humble_rpi-plugin-led'

    rpi = HumbleRPiPluginLed.new(settings: {pins: [27, 17, 22]})
    rpi.on_led_message '1 on'

    # or if you use an RGB LED ...

    rpi = HumbleRPiPluginLed.new(settings: {rgb: {pins: [27, 17, 22]}})
    rpi.on_led_message 'steelblue on'

## Resources

* humble_rpi-plugin-led https://rubygems.org/gems/humble_rpi-plugin-led
* humble_rpi https://rubygems.org/gems/humble_rpi

humblerpi plugin led humblerpipluginled

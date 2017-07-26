#!/usr/bin/env ruby

# file: humble_rpi-plugin-led.rb

require 'rpi_led'



class HumbleRPiPluginLed

  def initialize(settings: {}, variables: {})

    x = settings[:pins]
    
    pins = case x
    when Fixnum
      [x]
    when Integer
      [x]      
    when String
      [x]
    when Array
      x
    end
    
    @lookup = {}
    @gpio_pins = []
    
    # each pin can contain an identifier e.g. pins = [{'4': 'record'}, 17]
    # an LED can be identified by the identifier instead of the numberic index

    pins.each do |x|
    
      if x.is_a? Integer then

        @lookup.merge!(x.to_s.to_sym => x )
        @gpio_pins << x

      elsif x.is_a? Hash

        n = x.keys.first.to_s

        led_name = x[n.to_sym]
        @lookup.merge!(n.to_sym => n.to_i )
        @lookup.merge!(led_name.to_sym => n.to_i )
        @gpio_pins << n.to_i
      end

    end
        
  end
  
  def on_led_message(message)
            
    r = message.match(/(\w+)\s*(on|off|blink)\s*([\d\.]+)?(?:\s*duration\s)?([\d\.]+)?/)

    if r then
      index, state, seconds, raw_duration = r.captures
      duration = raw_duration ? raw_duration.to_f : nil

      a = case state

        when 'on'
          [:on, duration]

        when 'off'
          [:off]

        when 'blink'
          seconds = seconds ? seconds.to_f : 0.5
          [:blink, seconds, duration: duration]
      end

      @led[@lookup[index].to_i].send(*a)
    end
  end

  def start()
    
    if @gpio_pins.any?  then
      @led = @gpio_pins.map{|x| RPiLed.new x}
    end
    
  end
  
  alias on_start start
    
  
end

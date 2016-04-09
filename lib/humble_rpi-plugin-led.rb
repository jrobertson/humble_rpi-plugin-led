#!/usr/bin/env ruby

# file: humble_rpi-plugin-led.rb

#require 'rpi_led'
require 'requestor'

eval Requestor.read('http://rorbuilder.info/r/ruby'){|x| x.require 'rpi_led'}


class HumbleRPiPluginLed

  def initialize(settings: {}, variables: {})

    x = settings[:pins]
    
    @gpio_pins = case x
    when Fixnum
      [x]
    when String
      [x]
    when Array
      x
    end
    
  end
  
  def on_led_message(message)
            
    r = message.match(/(\d+)\s*(on|off|blink)\s*([\d\.]+)?(?:\s*duration\s)?([\d\.]+)?/)

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

      @led[index.to_i].send(*a)
    end
  end

  def start()
    
    if @gpio_pins.any?  then
      @led = @gpio_pins.map{|x| RPiLed.new x}
    end
    
  end
  
  alias on_start start
    
  
end
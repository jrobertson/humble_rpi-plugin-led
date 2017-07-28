#!/usr/bin/env ruby

# file: humble_rpi-plugin-led.rb

require 'rpi_rgb'



class HumbleRPiPluginLed
      

  def initialize(settings: {}, variables: {})

    x = settings[:pins] || []
    rgb = settings[:rgb]
    
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
    @led = []
    
    # each pin can contain an identifier e.g. pins = [{'4': 'record'}, 17]
    # an LED can be identified by the identifier instead of the numberic index

    initialize_leds(pins) {|pin| RPiLed.new pin} if pins.any?

    if rgb then
      

      colours = %i(red green blue)
      
      named_pins = rgb[:pins].zip(colours).map do |pin, colour| 
        {pin.to_s.to_sym => colour.to_s}
      end
      
      
      presets = {
        pink: '#FFC0CB',
        purple: '#800080', 
        turquoise: '#40E0D0',
        steelblue: '#4682B4',
        yellow: '#FFFF00',
        orange: '#FFA500',        
        goldenrod: '#DAA520'
      }            
      
      rgb_led = RPiRGB.new(rgb[:pins], presets: presets)
      index = @led.length
      @lookup[:red] = @lookup[index.to_s.to_sym] = index
      @lookup[:green]  = @lookup[(index+1).to_s.to_sym]= index
      @lookup[:blue]  = @lookup[(index+2).to_s.to_sym]= index
      
      presets.each {|preset| @lookup[preset] = index}

      
      @led <<  rgb_led

    end
        
  end
  
  def initialize_leds(pins)
    
    pins.each.with_index do |x, i|
 
      pin = if x.is_a? String or x.is_a? Integer then

        @lookup.merge!(i.to_s.to_sym => i )
        x

      elsif x.is_a? Hash

        n = x.keys.first.to_s

        led_name = x[n.to_sym]
        @lookup.merge!(i.to_s.to_sym => i )
        @lookup.merge!(led_name.to_sym => i )
        n

      end
      
      @gpio_pins << pin.to_i
      @led <<  yield(pin.to_i) if block_given?                

    end    
  end
  
  def on_led_message(message)
            
    r = message.match(/(\w+)\s*(on|off|blink)\s*([\d\.]+)?(?:\s*duration\s)?([\d\.]+)?/)

    if r then
      
      identifier, state, seconds, raw_duration = r.captures
      duration = raw_duration ? raw_duration.to_f : nil
      
      seconds = seconds ? seconds.to_f : 0.5      

      a = case state

        when 'on'
          [:on, duration]

        when 'off'
          [:off]

        when 'blink'

          [:blink, seconds, duration: duration]
      end

      
      led = @led[@lookup[identifier.to_sym].to_i]

      if led.is_a? RPiLed then
        
        led.send(*a)
        
      elsif led.is_a? RPiRGB

        if  state == 'on' then
          
          a = ((@led.length-1)..@led.length+1).map{|x| x.to_s.to_sym}
          h = a.zip(%i(red green blue)).to_h

          colour = h[identifier.to_sym]


          led.colour = colour || identifier
          led.on duration
          
        elsif state == 'off' 
          
          led.off
          
        elsif state == 'blink' 
          
          led.blink seconds, duration: duration
          
        end
        
      end
    end
  end

  def start()
    
  end
  
  alias on_start start
    
  
end
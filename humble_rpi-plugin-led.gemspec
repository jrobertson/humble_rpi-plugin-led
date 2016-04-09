Gem::Specification.new do |s|
  s.name = 'humble_rpi-plugin-led'
  s.version = '0.2.1'
  s.summary = 'A humble_rpi plugin for LEDs'
  s.authors = ['James Robertson']
  s.files = Dir['lib/humble_rpi-plugin-led.rb']
  s.add_runtime_dependency('rpi_led', '~> 0.1', '>=0.1.1')
  s.signing_key = '../privatekeys/humble_rpi-plugin-led.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/humble_rpi-plugin-led'
end

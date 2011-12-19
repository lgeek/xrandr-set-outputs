#!/usr/bin/env ruby

@enabled_outputs = ["HDMI1", "VGA1", "LVDS1"]
@max_enabled_outputs = 2
@position = '--right-of'

# A connected output looks like this 'HDMI1 connected[...]'
def get_connected_outputs
  outputs = []

  xrandr_output = `xrandr | grep " connected"`
  xrandr_output.each_line do |line|
    outputs.push line.split(' ')[0]
  end
  
  return outputs
end

# An enabled output looks like this 'HDMI1 (dis)connected 1920x1080+0+0[...]'
def get_enabled_outputs
  outputs = []

  xrandr_output = `xrandr |grep 'connected [0-9]'`
  xrandr_output.each_line do |line|
    outputs.push line.split(' ')[0]
  end
  
  return outputs
end

def disable_output(name)
  `xrandr --output #{name} --off`
end

def enable_output(name)
  `xrandr --output #{name} --auto`
end

connected_outputs = get_connected_outputs()
enabled_outputs = get_enabled_outputs()

outputs_to_disable = enabled_outputs
outputs_to_enable = []

@enabled_outputs.each do |output|
  if outputs_to_enable.size < @max_enabled_outputs and connected_outputs.include?(output)
    outputs_to_enable.push output
    outputs_to_disable.delete output
  end
end

outputs_to_disable.map { |output| disable_output(output)}
outputs_to_enable.map { |output| enable_output(output)}

for i in 1..(outputs_to_enable.size - 1)
  `xrandr --output #{outputs_to_enable[i]} #{@position} #{outputs_to_enable[i-1]}`
end

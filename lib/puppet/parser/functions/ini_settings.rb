module Puppet::Parser::Functions
  newfunction(:ini_settings, :type => :rvalue, :doc => <<-EOS
Creates a hue.ini sections and subsections from a hash:
    $settings = {  section1 => {
        setting1 => val1
      },
      section2 => {
        setting2 => val2,
        subsection1 => {
          setting3 => val3
        }
      }
    }
  [section1]
    setting1=val1
  [section2]
    setting2=val2
    [[subsection1]]
      setting3=val3
EOS
  ) do |arguments|
    raise(Puppet::ParseError, "ini_settings(): Wrong number of arguments") if arguments.size != 1
    raise(Puppet::ParseError, "ini_settings(): Not an hash") if !arguments[0].is_a?(Hash)

    return ini_section(arguments[0])
  end
end

def ini_section(section, n=1)
  ini = []
  section.each do |k,v|
    if v.is_a?(Hash)
      ini << ("  " * n) + ("[" * n) + k + ("]" * n)
      ini << ini_section(v, n + 1)
    else
      ini << ("  " * (n + 1)) + "#{k}=#{v}"
    end
  end
  return ini.join("\n") + "\n"
end


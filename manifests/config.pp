class hue::config (
  $hue_config_file,
  $config_values,
){
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  $hue_config = deep_merge($hue::config_defaults, $config_values)

  file { $hue_config_file:
    ensure  => file,
    content => template('hue/conf/hue.ini.erb'),
    mode    => '0644',
    owner   => 'hue',
    group   => 'hue',
    notify  => Service[ $hue::service_name ],
    require => Exec[ 'install_hue' ],
  }
}

class hue::service {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  file { "${hue::service_name}.service":
    ensure  => file,
    path    => "/etc/systemd/system/${hue::service_name}.service",
    mode    => '0644',
    content => template('hue/service/unit.erb'),
  }
  exec { "${hue::service_name}-reload":
    path        => '/bin:/usr/bin:/sbin:/usr/sbin',
    command     => 'systemctl daemon-reload',
    refreshonly => true,
  }
  service { $hue::service_name:
    ensure     => $hue::service_ensure,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  File[ "${hue::service_name}.service" ] ~>
  Exec[ "${hue::service_name}-reload" ] ->
  Service[ $hue::service_name ]
}

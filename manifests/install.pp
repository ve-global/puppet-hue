class hue::install(
  $hue_releases_archive_url,
  $hue_release_package_file,
  $hue_release_package_folder,
  $hue_install_dir,
  $hue_log_dir,
  $common_packages,
  $os_specific_packages,
  $hue_user,
  $hue_group,
) {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  $working_dir     = '/tmp'
  $local_repo_dir  = "${working_dir}/hue"

  ensure_resource('Package', $common_packages, { ensure => present } )
  ensure_resource('Package', $os_specific_packages, {ensure => present} )

  # Rsync must be checked this way or will complain about re-definition :-(
  if !defined (Package['rsync']) {
    package { 'rsync':
      ensure => present,
      before => Exec[ 'install_hue' ],
    }
  }

  user { $hue_user:
    ensure     => present,
    name       => $hue_user,
    managehome => true,
    shell      => '/bin/bash',
  }

  exec { 'download_hue_package':
    command => "/usr/bin/wget ${hue_releases_archive_url}/${hue_release_package_file}",
    cwd     => $working_dir,
    user    => $hue_user,
    creates => "${working_dir}/${hue_release_package_file}",
    require => User[$hue_user],
  }

  exec { 'decompress_hue_package':
    command => "/usr/bin/tar -zxvf ${hue_release_package_file}",
    cwd     => $working_dir,
    user    => $hue_user,
    creates => "${working_dir}/${hue_release_package_folder}",
    require => Exec['download_hue_package'],
  }

  exec { 'install_hue':
    command => "/usr/bin/make install PREFIX=${hue_install_dir}",
    cwd     => "${working_dir}/${hue_release_package_folder}",
    creates => "${hue_install_dir}/hue",
    user    => $hue_user,
    timeout => '0',
    require => [ Exec['decompress_hue_package'], Package[ $common_packages, $os_specific_packages ]],
  }

  file { $hue_log_dir:
    ensure  => directory,
    owner   => $hue_user,
    group   => $hue_group,
    require => Exec['install_hue'],
  }

  # Change the logs dir to our desired path
  file { "${hue_install_dir}/hue/logs":
    ensure  => 'link',
    owner   => $hue_user,
    group   => $hue_group,
    force   => true,
    target  => $hue_log_dir,
    require => File[$hue_log_dir],
  }
}

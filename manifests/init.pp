# == Class: hue
#
# This class will download, install and configure Cloudera's HUE
#
# === Authors
#
# Alejandro Montero <alejandro.montero@veinteractive.com>
#
class hue (
  $version                    = $hue::params::version,
  $mirror_url                 = $hue::params::mirror_url,
  $config_values              = $hue::params::config_values,
  $hue_log_dir                = $hue::params::hue_log_dir,
  $hue_install_dir            = $hue::params::hue_install_dir,
  $hue_config_file            = $hue::params::hue_config_file,
  $hue_bin_dir                = $hue::params::hue_bin_dir,
  $common_packages            = $hue::params::common_packages,
  $os_specific_packages       = $hue::params::os_specific_packages,
  $hue_user                   = $hue::params::hue_user,
  $hue_group                  = $hue::params::hue_group,
  $service_name               = $hue::params::service_name,
  $extra_classpath            = $hue::params::extra_classpath,
) inherits hue::params {

  $hue_release_package_file   = "hue-${version}.tgz"
  $hue_releases_archive_url   = "${mirror_url}/${version}"
  $hue_release_package_folder = "hue-${version}"

  anchor { 'hue::begin': } ->
  class { '::hue::install':
    hue_install_dir            => $hue_install_dir,
    hue_releases_archive_url   => $hue_releases_archive_url,
    hue_release_package_file   => $hue_release_package_file,
    hue_release_package_folder => $hue_release_package_folder,
    hue_log_dir                => $hue_log_dir,
    common_packages            => $common_packages,
    os_specific_packages       => $os_specific_packages,
    hue_user                   => $hue_user,
    hue_group                  => $hue_group,
  } ->
  class { '::hue::config':
    hue_config_file => $hue_config_file,
    config_values   => $config_values,
  } ~>
  class { '::hue::service': } ->
  anchor { 'hue::end': }

}

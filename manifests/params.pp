class hue::params {
  $version                    = '3.9.0'
  $mirror_url                 = 'https://gethue.com/downloads/releases'
  $hue_install_dir            = '/home/hue'
  $hue_config_file            = "${hue_install_dir}/hue/desktop/conf/hue.ini"
  $hue_bin_dir                = "${hue_install_dir}/hue/build/env/bin"
  $hue_log_dir                = '/var/log/hue'
  $hue_user                   = 'hue'
  $hue_group                  = 'hue'
  $service_name               = 'hue'
  $extra_classpath            = undef
  $common_packages            = ['wget', 'ant', 'gcc', 'make', 'maven',]

  case downcase($::osfamily) {
    'redhat': {
      $os_specific_packages = [
        'asciidoc', 'cyrus-sasl-devel', 'cyrus-sasl-gssapi', 'cyrus-sasl-plain', 'gcc-c++', 'krb5-devel',
        'libxml2-devel', 'libxslt-devel', 'mariadb-devel', 'openldap-devel', 'python-devel', 'sqlite-devel',
        'openssl-devel', 'gmp-devel', 'libffi-devel', 'mysql-connector-java',
      ]
    }

    default: {
      fail("The OS family ${::osfamily} is not yet supported.")
    }
  }

  # default config
  $config_defaults = {
    'desktop' => {
      'secret_key'           => '',
      'http_host'            => '0.0.0.0',
      'http_port'            => '8888',
      'time_zone'            => 'America/Los_Angeles',
      'django_debug_mode'    => false,
      'http_500_debug_mode'  => false,
      'allowed_hosts'        => '*',
    },
    'notebook' => {
      'interpreters' => {
        'hive' => {
          'name'      => 'Hive',
          'interface' => 'hiveserver2',
        },
        'impala' => {
          'name'      => 'Impala',
          'interface' => 'hiveserver2',
        },
        'spark' => {
          'name'      => 'Scala',
          'interface' => 'livy',
        },
        'pyspark' => {
          'name'      => 'PySpark',
          'interface' => 'livy',
        },
        'r' => {
          'name'      => 'R',
          'interface' => 'livy',
        },
        'jar' => {
          'name'      => 'Spark Submit Jar',
          'interface' => 'livy-batch',
        },
        'py' => {
          'name'      => 'Spark Submit Python',
          'interface' => 'livy-batch',
        },
        'pig' => {
          'name'      => 'Pig',
          'interface' => 'oozie',
        },
        'text' => {
          'name'      => 'Text',
          'interface' => 'text',
        },
        'markdown' => {
          'name'      => 'Markdown',
          'interface' => 'text',
        },
        'mysql' => {
          'name'      => 'MySQL',
          'interface' => 'rdbms',
        },
        'sqlite' => {
          'name'      => 'SQLite',
          'interface' => 'rdbms',
        },
        'postgresql' => {
          'name'      => 'PostgreSQL',
          'interface' => 'rdbms',
        },
        'oracle' => {
          'name'      => 'Oracle',
          'interface' => 'rdbms',
        },
        'solr' => {
          'name'      => 'Solr SQL',
          'interface' => 'solr',
        },
        'java' => {
          'name'      => 'Java',
          'interface' => 'oozie',
        },
        'spark2' => {
          'name'      => 'Spark',
          'interface' => 'oozie',
        },
        'mapreduce' => {
          'name'      => 'MapReduce',
          'interface' => 'oozie',
        },
        'sqoop1' => {
          'name'      => 'Sqoop1',
          'interface' => 'oozie',
        },
        'distcp' => {
          'name'      => 'Distcp',
          'interface' => 'oozie',
        },
        'shell' => {
          'name'      => 'Shell',
          'interface' => 'oozie',
        },
      },
    },
    'hadoop' => {
      'hdfs_clusters' => {
        'default' => {
          'fs_defaultfs' => 'hdfs://localhost:8020',
        },
      },
      'yarn_clusters' => {
        'default' => {
          'submit_to' => 'True',
        },
      },
      'mapred_clusters' => {
        'default' => {
          'submit_to' => 'False',
        },
      },
    },
  }

}

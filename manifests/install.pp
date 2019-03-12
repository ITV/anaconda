class anaconda::install {

    include anaconda::params

    # Bug fix: the require will force a download even if it doesn't have to be installed
    exec { "install_anaconda":
        command => "/usr/bin/bash /tmp/${anaconda::params::installer} -b -p /opt/anaconda/eda",
        creates => "/opt/anaconda/eda",
        require => Exec["download_anaconda"],
    }

    # Bug fix: the onlyif prevents the download from happening
    # when it doesn't need to be installed
    # Avoid circular dependency on "install_anaconda", run if /opt/anaconda doesn't exist
    exec { "download_anaconda":
        command => "/usr/bin/wget -P /tmp ${anaconda::params::url}",
        creates => "/tmp/${anaconda::params::installer}",
        onlyif  => "/usr/bin/test ! -d /opt/anaconda/eda",
    }

    file { "/opt/anaconda/eda/.condarc":
        source => "puppet:///modules/anaconda/.condarc",
        ensure => present,
        require => Exec["install_anaconda"],
    }


}

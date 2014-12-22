class people::dpnl87 {

  # Applications
  include zsh
  include macvim
  include firefox
  include caffeine
  include dropbox
  include flux
  include mou
  include sizeup
  include spotify
  include iterm2::dev
  include chrome
  include hipchat
  #include libreoffice
  include skype
  include virtualbox
  include vagrant
  include totalfinder
  include atom
  include adium
  include vlc

  # Install custom vagrant plugins
  #vagrant::plugin { 'vagrant-cachier': }

  # Install custom vagrant boxes
  vagrant::box { 'centos-6.5/virtualbox':
    source => 'https://vagrantcloud.com/chef/boxes/centos-6.5/versions/1/providers/virtualbox.box'
  }

  # Configuration Setup
  $env = {
    directories => {
      home      => '/Users/dpaulus',
      dotfiles  => '/Users/dpaulus/.dotfiles'
    },
    dotfiles => [
      'zshrc',
      'vimrc.after',
      'zpreztorc',
    ],
    packages => {
      brew   => [
        'wget',
        'ssh-copy-id',
        'htop',
        'tree',
        'nmap',
        'awscli',
        'md5sha1sum',
        'boot2docker',
        'docker'
      ]
    }
  }

  # Install Brew Applications
  package { $env['packages']['brew']:
    provider => 'homebrew',
  }

  # Install Janus
  repository { 'janus':
    source => 'carlhuda/janus',
    path   => "${env['directories']['home']}/.vim",
  }
  ~> exec { 'Boostrap Janus':
    command     => 'rake',
    cwd         => "${env['directories']['home']}/.vim",
    refreshonly => true,
    environment => [
      "HOME=${env['directories']['home']}",
    ],
  }

  # Install Prezto
  repository { 'prezto':
    source => 'sorin-ionescu/prezto',
    path   => "${env['directories']['home']}/.zprezto",
  }

  # Dotfile Setup
  repository { 'dpnl87-dotfiles':
    source => 'dpnl87/dotfiles',
    path   => "${env['directories']['dotfiles']}",
  }
  -> people::dpnl87::dotfile::link { $env['dotfiles']:
    source_dir => $env['directories']['dotfiles'],
    dest_dir   => $env['directories']['home'],
  }

  # OSX Defaults
  boxen::osx_defaults { 'Expand save panel by default':
    domain => 'NSGlobalDomain',
    key    => 'NSNavPanelExpandedStateForSaveMode',
    value  => true,
  }
  boxen::osx_defaults { 'Expand save panel by default 2':
    domain => 'NSGlobalDomain',
    key    => 'NSNavPanelExpandedStateForSaveMode2',
    value  => true,
  }

  boxen::osx_defaults { 'Expand print panel by default':
    domain => 'NSGlobalDomain',
    key    => 'PMPrintingExpandedStateForPrint',
    value  => true,
  }
  boxen::osx_defaults { 'Expand print panel by default 2':
    domain => 'NSGlobalDomain',
    key    => 'PMPrintingExpandedStateForPrint2',
    value  => true,
  }

  boxen::osx_defaults { 'Save to disk (not to iCloud) by default':
    domain => 'NSGlobalDomain',
    key    => 'NSDocumentSaveNewDocumentsToCloud',
    value  => true,
  }

  boxen::osx_defaults { 'Automatically quit printer app':
    domain => 'com.apple.print.PrintingPrefs',
    key    => 'Quit When Finished',
    value  => true,
  }

  boxen::osx_defaults { 'Disable the “Are you sure you want to open this application?” dialog':
    domain => 'com.apple.LaunchServices',
    key    => 'LSQuarantine',
    value  => false,
  }

  boxen::osx_defaults { 'Disable Resume system-wide':
    domain => 'NSGlobalDomain',
    key    => 'NSQuitAlwaysKeepsWindows',
    value  => false,
  }

  boxen::osx_defaults { 'Reveal IP address, hostname, OS version, etc. when clicking the clock':
    domain => '/Library/Preferences/com.apple.loginwindow',
    key    => 'AdminHostInfo',
    value  => 'HostName',
  }

  boxen::osx_defaults { 'Disable smart quotes':
    domain => 'NSGlobalDomain',
    key    => 'NSAutomaticQuoteSubstitutionEnabled',
    value  => false,
  }


  # Misc Helpers until I can figure out where to put this
  define dotfile::link($source_dir, $dest_dir) {
    file { "${dest_dir}/.${name}":
      ensure => symlink,
      target => "${source_dir}/.${name}",
    }
  }

}

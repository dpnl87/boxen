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
  vagrant::plugin { 'vagrant-cachier': }

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
    ],
    packages => {
      brew   => [
        'wget',
        'nmap'
      ]
    }
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
}

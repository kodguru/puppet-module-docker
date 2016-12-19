# docker_version.rb

Facter.add('docker_version') do
  confine :kernel => 'Linux'

  setcode do
    docker_bin = '/usr/bin/docker'
    version = 'none'

    if File.file?(docker_bin)
      version = `#{docker_bin} version -f '{{.Server.Version}}'`.strip
    end

    version
  end
end

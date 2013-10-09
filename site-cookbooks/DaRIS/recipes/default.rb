include_recipe "java"

mflux_home = node['mediaflux']['home']
mflux_user = node['mediaflux']['user']
mflux_user_home = node['mediaflux']['user_home']
mflux_fs = node['mediaflux']['fs']
url = node['mediaflux']['installer_url']

user mflux_user do
  comment "MediaFlux service"
  system true
  shell "/bin/false"
  home mflux_user_home
end

directory mflux_home do
  owner mflux_user
end

directory mflux_user_home do
  owner mflux_user
end

directory "#{mflux_user_home}/bin" do
  owner mflux_user
end

log "url is #{url}" do
  level :debug
end

if url == 'unset' || url == 'change-me' 
  if ! ::File.exists?("#{mflux_home}/installer.jar")
    log 'You must either download the installer by hand' + 
        ' or set the mediaflux.installer_url attribute' do
      level :fatal
    end
    return
  end
else
  remote_file "#{mflux_home}/installer.jar" do
    action :create_if_missing
    source url
  end
end

bash "install-mediaflux" do 
  not_if { ::File.exists?("#{mflux_home}/PACKAGE.MF") }
  user mflux_user
  code <<-EOH
java -jar #{mflux_home}/installer.jar nogui << EOF
accept
#{mflux_home}
EOF
EOH
end

link "#{mflux_home}/volatile" do
  to mflux_fs
  only_if { ::File.directory?(mflux_fs) }
end

directory "#{mflux_home}/volatile" do
  owner mflux_user
  not_if { ::File.directory?(mflux_fs) }
end

['logs', 'tmp', 'database', 'stores', 'shopping'].each do |dir|
  directory "#{mflux_home}/volatile/#{dir}" do
    owner mflux_user
  end
end

# Ermm ... there's a security issue with putting the "rc" file here ...
template "#{mflux_user_home}/.mfluxrc" do 
  owner mflux_user
  mode 0600
  source "mfluxrc.erb"
  variables({
    :admin_password => node['mediaflux']['admin_password']
  })
end

template "#{mflux_home}/config/database/database.tcl" do 
  owner mflux_user
  source "database-tcl.erb"
  variables({
    :mflux_home => mflux_home
  })
end

template "#{mflux_home}/config/services/network.tcl" do 
  owner mflux_user
  source "network-tcl.erb"
  variables({
    :http_port => node['mediaflux']['http_port'],
    :https_port => node['mediaflux']['https_port']
  })
end

template "#{mflux_user_home}/bin/mediaflux" do 
  owner mflux_user
  source "mediaflux-init.erb"
  variables({
    :mflux_user => mflux_user,
    :mflux_user_home => mflux_user_home
  })
end

template "/etc/init.d/mediaflux" do 
  owner "root"
  source "mediaflux-init.erb"
  variables({
    :mflux_user => mflux_user,
    :mflux_user_home => mflux_user_home
  })
end

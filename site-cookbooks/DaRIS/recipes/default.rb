include_recipe "java"

mflux_home = node['mediaflux']['home']
mflux_fs = node['mediaflux']['fs']

user "mediaflux" do
  comment "MediaFlux server account"
  system true
  shell "/bin/false"
  home mflux_home
end

directory mflux_home do
  owner "mediaflux"
end

remote_file "${mflux_home}/installer.jar" do
  action :create_if_missing
  source node['mediaflux']['installer_url']
end

bash "install-mediaflux" do 
  not_if { ::File.exists("#{mflux_home}/PACKAGE.MF") }
  user "mediaflux"
  code <<-EOH
java -jar #{mflux_home}/installer.jar nogui << EOF
accept
#{mflux_home}
EOF
EOH
end

link "#{mflux_home}/volatile}" do
  to mflux_fs
  only_if { ::Directory.exists(mflux_fs) }
end

directory "#{mflux_home}/volatile}" do
  owner "mediaflux"
  not_if { ::Directory.exists(mflux_fs) }
end

directory "#{mflux_home}/volatile/logs" do
  owner "mediaflux"
end

directory "#{mflux_home}/volatile/tmp" do
  owner "mediaflux"
end

directory "#{mflux_home}/volatile/database" do
  owner "mediaflux"
end

directory "#{mflux_home}/volatile/stores" do
  owner "mediaflux"
end

directory "#{mflux_home}/volatile/shopping" do
  owner "mediaflux"
end

template "#{mflux_home}/.mfluxrc" do 
  owner "mediaflux"
  mode 0600
  source "mfluxrc.erb"
  variables({
    :admin_password => node['mediaflux']['admin_password']
  })
end

template "#{mflux_home}/config/database/database.tcl" do 
  owner "mediaflux"
  source "database-tcl.erb"
  variables({
    :mflux_home => mflux_home
  })
end

template "#{mflux_home}/config/services/network.tcl" do 
  owner "mediaflux"
  source "network-tcl.erb"
  variables({
    :http_port => node['media_flux']['http_port'],
    :https_port => node['media_flux']['https_port']
  })
end







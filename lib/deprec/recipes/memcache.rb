# Copyright 2006-2008 by Mike Bailey. All rights reserved.
Capistrano::Configuration.instance(:must_exist).load do 
  namespace :deprec do
    namespace :memcache do
      
  set :memcache_ip, '127.0.0.1'
  set :memcache_port, 11211
  set :memcache_memory, 256
  
  # XXX needs thought/work
  task :memcached_start do
    run "memcached -d -m #{memcache_memory} -l #{memcache_ip} -p #{memcache_port}"
  end
  
  # XXX needs thought/work
  task :memcached_stop do
    run "killall memcached"
  end
  
  # XXX needs thought/work
  task :memcached_restart do
    memcached_stop
    memcached_start
  end

  task :install_memcached do
    version = 'memcached-1.4.5'
    set :src_package, {
      :file => version + '.tar.gz',   
      :md5sum => '583441a25f937360624024f2881e5ea8  memcached-1.4.5.tar.gz', 
      :dir => version,  
      :url => "http://www.danga.com/memcached/dist/#{version}.tar.gz",
      :unpack => "tar zxf #{version}.tar.gz;",
      :configure => %w{
        ./configure
        --prefix=/usr/local 
        ;
        }.reject{|arg| arg.match '#'}.join(' '),
      :make => 'make;',
      :install => 'make install;',
      :post_install => 'install -b scripts/memcached-init /etc/init.d/memcached;'
    }
    apt.install( {:base => %w(libevent-dev)}, :stable )
    deprec.download_src(src_package, src_dir)
    deprec.install_from_src(src_package, src_dir)
  end
end end
  
end
# -*- mode: ruby -*-

# vim: set ft=ruby :



MACHINES = {

  :otuslinux => {

        :box_name => "ubuntu/focal64",

        :disks => {

                :sata1 => {

                        :dfile => './d1.vdi',

                        :size => 250,

                        :port => 4

                },

                :sata2 => {

                        :dfile => './d2.vdi',

                        :size => 250, # Megabytes

                        :port => 5

                },

                :sata3 => {

                        :dfile => './d3.vdi',

                        :size => 250,

                        :port => 6

                },

                :sata4 => {

                        :dfile => './d4.vdi',

                        :size => 250, # Megabytes

                        :port => 7

                }



        }





  },

}



Vagrant.configure("2") do |config|



  MACHINES.each do |boxname, boxconfig|



      config.vm.define boxname do |box|



          box.vm.box = boxconfig[:box_name]

          box.vm.host_name = boxname.to_s


          box.vm.provider :virtualbox do |vb|

                  vb.customize ["modifyvm", :id, "--memory", "1024"]

                  needsController = false

                  boxconfig[:disks].each do |dname, dconf|

                          unless File.exist?(dconf[:dfile])

                                vb.customize ['createhd', '--filename', dconf[:dfile], '--variant', 'Fixed', '--size', dconf[:size]]

                                needsController =  true

                          end



                  end

                  if needsController == true

                     boxconfig[:disks].each do |dname, dconf|

                         vb.customize ['storageattach', :id,  '--storagectl', 'SCSI', '--port', dconf[:port], '--device', 0, '--type', 'hdd', '--medium', dconf[:dfile]]

                     end

                  end

          end

         # box.vm.provision "shell", inline: <<-SHELL

          #    mkdir -p ~root/.ssh

           #   cp ~vagrant/.ssh/auth* ~root/.ssh

            #  yum install -y mdadm smartmontools hdparm gdisk

        #  SHELL



      end

  end

end

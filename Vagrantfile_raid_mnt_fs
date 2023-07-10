# -*- mode: ruby -*-

# vim: set ft=ruby :



MACHINES = {

  :otussega => {

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
config.vm.provision "shell", inline: <<-SHELL
   # Install mdadm for RAID configuration
    #sudo apt-get update
    #sudo apt-get install -y mdadm

    # Create the RAID array
    sudo mdadm --zero-superblock --force /dev/sdc /dev/sdd
    sudo mdadm --create --verbose --metadata=0.90 /dev/md123 -l 1 -n 2 /dev/sdc /dev/sdd

    # Format the RAID array with GPT partition table
    sudo parted -s /dev/md123 mklabel gpt

    # Create 5 partitions
    sudo parted -s /dev/md123 mkpart primary ext4 0% 20%
    sudo parted -s /dev/md123 mkpart primary ext4 20% 40%
    sudo parted -s /dev/md123 mkpart primary ext4 40% 60%
    sudo parted -s /dev/md123 mkpart primary ext4 60% 80%
    sudo parted -s /dev/md123 mkpart primary ext4 80% 100%

    # Add RAID array to mdadm.conf
    sudo rm /etc/mdadm/mdadm.conf
    touch ~/mdadm.conf
    sudo echo "DEVICE partitions" > ~/mdadm.conf
    sudo mdadm --detail --scan | awk '/ARRAY/{print}'  >> ~/mdadm.conf
    sudo mv ~/mdadm.conf /etc/mdadm/mdadm.conf

    # Format partitions with ext4 file system
    for i in $(seq 1 5); do mkfs.ext4 /dev/md123p$i; done

    # Create mount points
    mkdir -p /raid/part{1,2,3,4,5}

    # Update initramfs
    sudo update-initramfs -u

    # Mount the partitions
    for i in $(seq 1 5); do sudo mount /dev/md123p$i /raid/part$i; done

    echo "/dev/md123p1   /raid/part1   ext4   defaults   0   0" | sudo tee -a /etc/fstab
    echo "/dev/md123p2   /raid/part2   ext4   defaults   0   0" | sudo tee -a /etc/fstab
    echo "/dev/md123p3   /raid/part3   ext4   defaults   0   0" | sudo tee -a /etc/fstab
    echo "/dev/md123p4   /raid/part4   ext4   defaults   0   0" | sudo tee -a /etc/fstab
    echo "/dev/md123p5   /raid/part5   ext4   defaults   0   0" | sudo tee -a /etc/fstab
     SHELL
   end

  end
end

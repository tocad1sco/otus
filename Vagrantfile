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
box.vm.provision "shell", inline: <<-SHELL
   # Install mdadm for RAID configuration
    sudo apt-get update
    sudo apt-get install -y mdadm

    # Create the RAID array
    sudo mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/sdb /dev/sdc /dev/sdd

    # Format the RAID array with GPT partition table
    sudo parted -s /dev/md0 mklabel gpt

    # Create 5 partitions
    sudo parted -s /dev/md0 mkpart primary ext4 0% 20%
    sudo parted -s /dev/md0 mkpart primary ext4 20% 40%
    sudo parted -s /dev/md0 mkpart primary ext4 40% 60%
    sudo parted -s /dev/md0 mkpart primary ext4 60% 80%
    sudo parted -s /dev/md0 mkpart primary ext4 80% 100%

    # Format partitions with ext4 file system
    sudo mkfs.ext4 /dev/md0p1
    sudo mkfs.ext4 /dev/md0p2
    sudo mkfs.ext4 /dev/md0p3
    sudo mkfs.ext4 /dev/md0p4
    sudo mkfs.ext4 /dev/md0p5

    # Create mount points
    sudo mkdir -p /raid/part1
    sudo mkdir -p /raid/part2
    sudo mkdir -p /raid/part3
    sudo mkdir -p /raid/part4
    sudo mkdir -p /raid/part5

    # Add RAID array to mdadm.conf
    echo "DEVICE /dev/sdb /dev/sdc /dev/sdd" | sudo tee -a /etc/mdadm/mdadm.conf
    sudo mdadm --detail --scan | grep ARRAY | sudo tee -a /etc/mdadm/mdadm.conf

    # Update initramfs
    sudo update-initramfs -u

    # Mount the partitions
    sudo mount /dev/md0p1 /raid/part1
    sudo mount /dev/md0p2 /raid/part2
    sudo mount /dev/md0p3 /raid/part3
    sudo mount /dev/md0p4 /raid/part4
    sudo mount /dev/md0p5 /raid/part5

    # Update /etc/fstab to mount partitions on boot
    echo "/dev/md0p1   /raid/part1   ext4   defaults   0   0" | sudo tee -a /etc/fstab
    echo "/dev/md0p2   /raid/part2   ext4   defaults   0   0" | sudo tee -a /etc/fstab
    echo "/dev/md0p3   /raid/part3   ext4   defaults   0   0" | sudo tee -a /etc/fstab
    echo "/dev/md0p4   /raid/part4   ext4   defaults   0   0" | sudo tee -a /etc/fstab
    echo "/dev/md0p5   /raid/part5   ext4   defaults   0   0" | sudo tee -a /etc/fstab
  SHELL
end


      end

  end

end

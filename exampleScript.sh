#!/usr/bin/python
# Example script that uses the progkey.py command to enter a sequence of commands on a Yun-connected computer.

# This particular example manually installs an NVIDIA driver on an Ubuntu 12.04 Linux system. It assumes that the Nouveau driver has already been blacklisted (`sudo echo 'blacklist nouveau' >/etc/modprobe.d/nvidia.conf`), the machine has been rebooted, and the machine has already been logged in to the Unity GUI. Also assumes that the driver has been downloaded to the ~/Downloads folder.

# Setting up the variables
PYCOM='python progkey.py'                      # Command to launch the script
YUNIP='192.168.240.1'                          # IP address of the Yun. Currently set to the self-assigned IP that a Yun gives itself by default.
NVDVR='NVIDIA-Linux-x86_64-331.38.run'         # NVIDIA Driver Installer

# Command queue
${PYCOM} ${YUNIP} -c 'h128/h130/p195/r-1'      # Ctrl-Alt-F2 - to switch to VT-2
sleep 3                                        # Wait for the switch
${PYCOM} ${YUNIP} 'username'                   # Replace 'username' with an administrator username
${PYCOM} ${YUNIP} 'password'                   # Replace 'password' with the administrator password
${PYCOM} ${YUNIP} 'sudo su'                    
${PYCOM} ${YUNIP} 'password'                   # Again replace 'password' with the administrator password
${PYCOM} ${YUNIP} 'service lightdm stop'       # Exit X/Unity
${PYCOM} ${YUNIP} 'cd Downloads'
${PYCOM} ${YUNIP} "./${NVDVR} -aq"             # Run the NVIDIA driver installer, accepting the license and assuming "yes" to most questions.
${PYCOM} ${YUNIP} -c 'p176'                    # Return/Enter - to make sure the installer starts, just in case.
sleep 30                                       # -- Installing --
${PYCOM} ${YUNIP} -c 'p176'                    # Return/Enter - to close the "dialog box"
sleep 20                                       # -- Installing --
${PYCOM} ${YUNIP} -c 'p176'                    # Return/Enter - to close the final "dialog box"
sleep 2                                        # -- Wait for installer to close --
${PYCOM} ${YUNIP} 'reboot'                     # Restart the machine
sleep 23                                       # -- Wait for grub boot screen, if any --
${PYCOM} ${YUNIP} -c 'p176'                    # Return/Enter - for the default option
sleep 25                                       # -- Continue booting --
${PYCOM} ${YUNIP} 'password'                   # Assumes the default user is the administrator, enter the password here
sleep 10                                       # -- Continue booting --
${PYCOM} ${YUNIP} -c 'p131'                    # Command/GUI key - To bring up the launcher
sleep 3                                        # -- Wait for launcher to load --
${PYCOM} ${YUNIP} 'Terminal'                   # Launch the GNOME Terminal
sleep 3                                        # -- Wait for results to finish populating --
${PYCOM} ${YUNIP} -c 'p176'                    # Return/Enter - to make sure the Terminal launches
sleep 2                                        # -- Wait for Terminal app --
${PYCOM} ${YUNIP} 'nvidia-settings'            # Launch nvidia-settings to verify installation
sleep 2                                        # -- Wait for NVIDIA Settings to launch --
${PYCOM} ${YUNIP} -c 'h129/p179/r129/p176'     # Shift-Tab, then return - to close the NVIDIA Settings app
sleep 2                                        # -- Wait for another dialog --
${PYCOM} ${YUNIP} -c 'p179/p176'               # Tab, then Return - to close the dialog

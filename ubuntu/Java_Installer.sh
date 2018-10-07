#!/bin/bash
echo "Download jdk from here \n\n http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html \n"
echo "After downloading press enter"
read down

echo "Copy jdk-*-linux-*.bin file to home"

echo "After copying the file press enter"
read ok
echo "So here we go....zooooooom...."
sudo chmod 755 jdk-*-linux-*.bin
./jdk-*-linux-*.bin
sudo mkdir -p /usr/lib/jvm
sudo mv jdk???????? /usr/lib/jvm/
sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk*/bin/java" 1
sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk*/bin/javac" 1
sudo update-alternatives --install "/usr/lib/mozilla/plugins/libjavaplugin.so" "mozilla-javaplugin.so" "/usr/lib/jvm/jdk*/jre/lib/i386/libnpjp2.so" 1
sudo update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/lib/jvm/jre*/bin/javaws" 1


echo "Do you want to make the installed java as default?\n y for yes/any key for no"
read ans

if [ $ans = "y" ]	
 then   sudo update-alternatives --config java 
        sudo update-alternatives --config javac 
	sudo update-alternatives --config mozilla-javaplugin.so 
	sudo update-alternatives --config javaws 
else echo fine
fi

echo "Congratulations!!! java is successfully installed :)"

<b>YOU NEED DOCKER, and to be able to run docker build as a normal user (check your distribution specifics)</b>

<h3> Setup </h3>
<div>
<ol>
<li>  Clone this repository</li>

<code>
 git clone https://github.com/mikakev1/MildInstaller.git
</code>

<li>  Change directory </li>
<code>
  cd MildInstaller
</code>
<li>  To see which settings are available </li>
<code>
 ./01-build_container.sh --help
</code>
<li>  Build it using the selected options to speed up the process, or be prepared to wait </li>
<code> 
 ./01-build_container.sh 
</code>
<li>  (optional) Install Cemu inside the container  </li>
<code>
 ./03-build_cemu_container.sh
</code>
<li>  If you want to manages files in your container you can start any program like this : (files from your home will be available)</li>
<code>

#To run winefile when container is stopped (you can also run wineconsole that way too) 

./04-run_cemu.sh --entrypoint winefile

#To run a shelli when container is stopped

./04-run_cemu.sh -it --entrypoint bash

#To run winfile when container is running

docker exec kazhed-cemu winefile

#To run bash when container is running

docker exec -it kazhed-cemu  bash

#To save modifications in the IMAGE (a.k.a. commit changes)

docker commit kazhed-cemu kazhed/emulator_cemu


</code>



<li>  Depending if you followed the previous step do </li>
<emphase> for Cemu do not forget to include the file keys.txt in /cemu/latest/ folder of the container (check above) </emphase>
<code>
./02-run_container.sh 
 OR  
./04-run_cemu.sh
</code>

<li>  If you have an <emphase> arch </emphase> linux, you can update your mesa driver like this : </li>

<code>
 ./99-start_local_repository_and_update_mesa.sh
</code>
<br/>
</ol>
</div>

<h3>FAQ:</h3>
<div>
<ul>
<li><p>Q - Script exits nearly immediately stating that docker is not available</p><p>A - Check that docker is started, and that you're allowed to use it as a normal user (without sudo and the like) </p></li>
<li><p>Q - How can I add file.txt in my container</p><p>A - Check (8) </p></li>

<li><p>Q - Can I add another directory because I need it</p>
<p>A - Sure, edit the file called 02-run_container.sh or 04-run_container.sh and add it in the list called VISIBLE_DIRECTORIES</p> 
<p>Or you can use -v switch like this  '-v /mydirectory:/mydirectory'</p></li>

<li><p>Q - I do not have an ARCHLINUX, it's a derivative named "younameit" can I update drivers using your script?</p>
<p>A - Best thing I can say : try, but do not complain.</p></li>

<li><p> Q - I have two graphics cards, and I want to use the others, can I?</p>
<p>Q - I don't have pulseaudio, can I use alsa?</p>
<p>Q - Can I have more than one joystick?</p>
<p>A - Yes, you need to edit the file ( 02-run_container.sh  or 04-run_cemu.sh) and change DEVICE_DRIVERS to include the required device</p></li>
 
 <li><p>Q - It's too complex, is there something that is planned to address that?</p>
<p>A - Currently I have many things to do and not a lot of availability, I'm weighing up the possibility to setup that stuff using a web interface</p></li>
</ul>
</div>


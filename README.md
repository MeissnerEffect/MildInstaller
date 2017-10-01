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

<p> Pay attention to the differences between an image and a container </p>
<p> Container will be destroyed everytime after use, unless commited </p>
<p> Image will not update unless the whole process is restarted </p>


<li>  Check usage and the available options / applications</li>
<code>
  ./kazhedctl help
</code>

<li>  Build Image </li>
<strong> Build options, that appears in blue, can be used only once, so set them right at the beginning (or you'll need to restart everything from the beginning) </strong> 
<p> Example with strong optimisation that includes support for intel, radeon, nvidia and vulkan drivers [ container won't run on some X86-64 ]  </p>
<code>
  ./kazhedctl build
</code>
<p> Example with strongest optimisations for a radeon graphic card (GCN+) [ container won't run on some x86-64 ] </p>
<code>
  ./kazhedctl build --radeon --vukan --optlevel=15 
</code>
<p> Example with generic optimisation for an intel graphic card and wine staging, [ container will run on any  X86-64 ] </p>
<code>
  ./kazhedctl build --intel --vukan --optlevel=2 --experimental=wine
</code>

<li>  Install product (please consider helping developpers of opensource software) </li>
<strong> You can install but you can't remove unless you start from the beginning </strong> 
<p> To install dolphin, citra, rpcs3, decaf (check the list of options by using help command)
<code>
 ./kazhedctl install --dolphin --citra --rpcs3 --decaf
</code>

<li>  Configure container </li>
<strong> The configure command will overwrite previous "configure" settings</strong> 
<p> Example 1: Add the directory /srv/storage/games [ by default home will be included ]</p>
<code>
./kazhedctl configure --add-dir=/srv/storage/games 
</code>

<p> Example 2: Add the driver /dev/input/by-id/usb-Wireless_Receiver-event-joystick [ by default only the first joystick will be included ] </p>
<code>
./kazhedctl configure --add-device=/dev/input/by-id/usb-Wireless_Receiver-event-joystick
</code>

<li> You can combine everything in one commande like this </li>
<code>
./kazhedctl build --radeon --vukan --optlevel=15 --dolphin --add-device=/dev/input/by-id/usb-Wireless_Receiver-event-joystick --add-dir=/srv/storage/games
</code>


</ol>

</div>


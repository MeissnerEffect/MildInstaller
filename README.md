<b>YOU NEED DOCKER, and to be able to run docker build as a normal user (check your distribution specifics)</b>

<emphase> Pay attention to the differences between an image and a container 

 Container will be destroyed everytime after use, unless commited 

 Image will not update unless the whole process is restarted 
 </emphase>
<h2> I'm Testing at the moment </h2>
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

<li>  Check usage and the available options / applications</li>
<code>
  ./kazhedctl help

  Usage : kazhedctl

Prepare a new container that includes MesaMild

 MAIN COMMAND

    build                          Build image

    configure                      Configure container

    dump                           Dump packages

    help                           This help

    install                        Install applications

    prune                          Remove everything

    start                          Start/Restart container

    update                         Update image



 BUILD - DRIVER OPTIONS

    --intel                          Enable modern intel support

    --legacy=intel,radeon            Enable legacy radeon and intel drivers

    --nine                           Enable mesa and wine gallium-nine support

    --nouveau                        Enable nouveau support

    --radeon                         Enable radeon support

    --vulkan                         Enable vulkan with intel or radeon



 CONTAINER OPTIONS

    --add-device=X                   Add the char device X in the container

    --add-dir=X                      Add the X directory in the container



 INSTALL OPTIONS

    --cemu                           Install latest public version of CEMU              (http://cemu.info)

    --citra                          Build Citra from git                               (https://citra-emu.org)

    --decaf                          Build decaf from git                               (https://github.com/decaf-emu/decaf-emu/)

    --dolphin                        Build Dolphin from git                             (https://dolphin-emu.org/)

    --rpcs3                          Build RPCS3 from git                               (https://rpcs3.net)

    --steam                          Install steam                                      (https://store.steampowered.com/)


 BUILD - COMPILER OPTIONS

    --clang                          Build using CLANG

    --optimise=X                     Use optimisation level 0<=X<=15


 BUILD - IMAGE OPTIONS

    --experimental=wine,mesa,llvm    Use experimental version of packages [empty=all]
</code>

<li>  Build Image </li>
<strong> Build options, that appears in blue, can be used only once, so set them right at the beginning (or you'll need to restart everything from the beginning) </strong> 
<ul>
<li>
<p> Example with strong optimisation that includes support for intel, radeon, nvidia and vulkan drivers [ container won't run on some X86-64 ]  </p>
<code>
  ./kazhedctl build
</code></li>

<li><p> Example with strongest optimisations for a radeon graphic card (GCN+) [ container won't run on some x86-64 ] </p>
<code>
  ./kazhedctl build --radeon --vulkan --optlevel=15 
</code></li>
<li><p> Example with generic optimisation for an intel graphic card and wine staging, [ container will run on any  X86-64 ] </p>
<code>
  ./kazhedctl build --intel --vulkan --optlevel=2 --experimental=wine
</code></li>
</ul>
</div>


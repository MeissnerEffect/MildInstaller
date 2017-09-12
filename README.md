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
</div>

<p style="margin-bottom: 0cm; line-height: 100%"><font face="monospace"><font color="#000000"><span style="background: #ffffff">Usage
: Setup.sh </span></font><br/>
Prepare a new container that includes
MesaMild <br/>
<font color="#b21818"><span style="background: #ffffff">INSTALLER OPTIONS</span></font><br/>
<font color="#b21818"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #b21818">--dump-dl</span></font><font color="#b21818"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Dump all downloads for reuse</span></font><br/>
<font color="#b21818"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #b21818">--help</span></font><font color="#b21818"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;This help</span></font><br/>
<font color="#b21818"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #b21818">--prune</span></font><font color="#b21818"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Remove every containers and images from this application</span></font><br/>
<font color="#b21818"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #b21818">--trim</span></font><font color="#b21818"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Trim images</span></font><br/>
<font color="#b21818"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #b21818">--update</span></font><font color="#b21818"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Destroy previous image and restart build process</span></font><br/>
<br/>
<font color="#18b2b2"><span style="background: #ffffff">CONTAINER OPTIONS</span></font><br/>
<font color="#18b2b2"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #18b2b2">--add-device=X</span></font><font color="#18b2b2"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Add the char device X in the container</span></font><br/>
<font color="#18b2b2"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #18b2b2">--add-dir=X</span></font><font color="#18b2b2"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Add the X directory in the container</span></font><br/>
<font color="#18b2b2"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #18b2b2">--max-ram=X</span></font><font color="#18b2b2"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Hard memory limit</span></font><br/>
<font color="#18b2b2"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #18b2b2">--max-swap=X,Y</span></font><font color="#18b2b2"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Use max swap and define swapiness</span></font><br/>
<font color="#18b2b2"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #18b2b2">--use-cpu=X,Y,Z</span></font><font color="#18b2b2"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Use only enumerated CPU</span></font><br/>
<br/>
<font color="#b218b2"><span style="background: #ffffff">APPLICATIONS OPTIONS</span></font><br/>
<font color="#b218b2"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #b218b2">--cemu=X.Y.Z</span></font><font color="#b218b2"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Download the specified version of CEMU</span></font><br/>
<font color="#b218b2"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #b218b2">--citra</span></font><font color="#b218b2"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Build Citra from git</span></font><br/>
<font color="#b218b2"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #b218b2">--decaf</span></font><font color="#b218b2"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Build decaf from git</span></font><br/>
<font color="#b218b2"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #b218b2">--dolphin</span></font><font color="#b218b2"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Build Dolphin from git</span></font><br/>
<font color="#b218b2"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #b218b2">--rpcs3</span></font><font color="#b218b2"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Build RPCS3 from git</span></font><br/>
<font color="#b218b2"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #b218b2">--steam</span></font><font color="#b218b2"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Install steam</span></font><br/>
<font color="#b218b2"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #b218b2">--wine-steam</span></font><font color="#b218b2"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Install steam (wine)</span></font><br/>
<br/>
<font color="#18b218"><span style="background: #ffffff">MESA OPTIONS</span></font><br/>
<font color="#18b218"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #18b218">--intel</span></font><font color="#18b218"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Enable intel support</span></font><br/>
<font color="#18b218"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #18b218">--intel-legacy</span></font><font color="#18b218"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Enable legacy intel support</span></font><br/>
<font color="#18b218"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #18b218">--nouveau</span></font><font color="#18b218"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Enable nouveau support</span></font><br/>
<font color="#18b218"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #18b218">--radeon</span></font><font color="#18b218"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Enable radeon support</span></font><br/>
<font color="#18b218"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #18b218">--radeon-legacy</span></font><font color="#18b218"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Enable legacy radeon support (PRE GCN)</span></font><br/>
<font color="#18b218"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #18b218">--vulkan</span></font><font color="#18b218"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Enable vulkan (intel or radeon)</span></font><br/>
<br/>
<font color="#b26818"><span style="background: #ffffff">OS OPTIONS</span></font><br/>
<font color="#b26818"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #b26818">--bleeding-edge</span></font><font color="#b26818"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Use bleeding edge version of packages, (for VEGA)</span></font><br/>
<font color="#b26818"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #b26818">--kerberizer-llvm</span></font><font color="#b26818"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Use LLVM from Kerberizer's repository (for RPCS3)</span></font><br/>
<font color="#b26818"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #b26818">--mesa-stable</span></font><font color="#b26818"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Use stable version of mesa</span></font><br/>
<font color="#b26818"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #b26818">--wine-staging</span></font><font color="#b26818"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Install wine staging instead of wine</span></font><br/>
<font color="#b26818"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #b26818">--wine-staging-nine</span></font><font color="#b26818"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;Install wine-staging-nine instead of wine</span></font><br/>
<br/>
<font color="#1818b2"><span style="background: #ffffff">COMPILER OPTIONS</span></font><br/>
<font color="#1818b2"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #1818b2">--clang</span></font><font color="#1818b2"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Build using CLANG</span></font><br/>
<font color="#1818b2"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #1818b2">--optimise</span></font><font color="#1818b2"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Use safe compiler optimisation</span></font><br/>
<font color="#1818b2"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #1818b2">--optimise-harder</span></font><font color="#1818b2"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Use unsafe compiler optimisation</span></font><br/>
<font color="#1818b2"><span style="background: #ffffff">&nbsp;&nbsp;&nbsp;</span></font><font color="#ffffff"><span style="background: #1818b2">--use-lto</span></font><font color="#1818b2"><span style="background: #ffffff">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Use link time optimisation (largely increase building time)</span></font><br/>
</font><br/>
<br/>

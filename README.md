# What Is PascalRPC?
PascalRPC is a Discord Rich Presence program with a Graphical User Interface written in Pascal. With it you can easily set custom statuses on Discord. With the Graphical User Interface you are easily able to navigate and change settings without fiddling with files, awkward command line programs, or code itself.

To download Discord or learn more about Discord RPC visit the links below. These are only for the curious and you probably already know about both.

Discord: <https://discordapp.com/>  
Discord RPC: <https://discordapp.com/rich-presence>

Check the images section at the very end to get a look at the program and its interface.

# How To Use
It is recommended to get an already compiled build from [releases](https://github.com/Commando950/PascalRPC/releases) to begin using this program as an end user. If you wish to compile this program read the Compiling section.

1. Create an application to use as the title of your status.   
   Go to [Discord Applications](https://discordapp.com/developers/applications) and create a new application.  
   Go to Rich Presence>Art Assets to add any art you would like to display on your status.  
   Before you leave be sure to get the Client ID.
2. Open PascalRPC and type in the Application ID box the Client ID you retrieved earlier.
3. Set desired settings.
4. Click Enable RPC.

To change the application you are using be sure to click Shutdown RPC and then enable it again.

# Compiling
NOTICE: Will work correctly on Windows 32 and 64 bit as well as 64 bit Linux. You may need to compile it in order to get it to work on your system.

To compile you need [Lazarus](https://www.lazarus-ide.org/) to either modify or compile this project.

This application also requires a [.DLL or .SO](https://github.com/discord/discord-rpc) to function. These are included in this repository due to the fact it was released under the MIT License, so I have no fear of redistributing it.

1. Open the PascalRPC.lpi project file using Lazarus.
2. Run>Build
3. Profit??!!

Be sure if you redistribute this that you include the .DLL or .SO file as the program will not work without it.

# Licensing
Read [LICENSE](../master/LICENSE) for more information.

# Images

![Image](https://github.com/Commando950/PascalRPC/raw/master/images/example.png "An example in action.")

*The image above demonstrates what rich presence looks like in use.*

![Image](https://github.com/Commando950/PascalRPC/raw/master/images/PascalRPC.png "The program interface.")

*The image above shows the program and its interface.*

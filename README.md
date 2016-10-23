### Simple PCIDSS Information and Configuration Extractor (SPICE)
Author: David Acosta (admin[at]pcihispano.com) from PCI Hispano www.pcihispano.com

## == Description ==
Simple PCIDSS Information and Configuration Extractor (SPICE) is a VERY SIMPLE console-based program for Microsoft Windows operating systems, designed to collect and export configuration data related with PCI DSS controls, aiming to QSA, ISA or administrators to review it offline in order to validate the application of settings described in the system hardening standard (req. 2.2). It is portable and does not need neither installation nor additional software to run (DLL, installers, compilers or interpreters). It performs basic validation rutines in specific variables with fixed values (password lenght, password expiration, password complexity and so on) and reports this results into a final log:

WARN: There is something wrong with extracted value
INFO: Everything is OK   

## == Installation ==
This program does not need installation. Just uncompress the .zip file and copy the main executable "SPICE_vX.X.bat" (where X.X is the current version) into a temporary folder.

== Execution ==
You need administrative privileges to execute this tool.
To run it: 
1. Go to the folder where the script was extracted
2. From a Command Prompt (cmd.exe) with administrative privileges execute the script.
3. If a problem is detected, it will be displayed in console  
4. When the program ends, a log (HOSTNAME.log) will be created on the "desktop" folder of the current user.

## == Frequently Asked Questions ==

= Could this tool modify my files? =
No. This tool only read, extract and export the configuration data from your PC/Server. It does not write, delete or modify any file or data from your systems. 

= Could this tool extract payment data stored in my systems? = 
No. All collected data is related to configuration settings and is exported into hostname.log file in text format. 

= How can I execute a Command Prompt (cmd.exe) with administrative privileges?
Because this program requires execution from a Command Prompt (cmd.exe) with administrative privileges, run these steps:
- Use "runas": runas /user:localmachinename\administrator cmd
- Use the contextual menu of "Run as administrator": Locate the icon of "Command Prompt" in the Start Menu - Right click -> Run as administrator
When this steps have been performed, go to the folder where the script was extracted and execute it. 

## == Changelog ==

= 0.1 (March 2014) =
* Upgrade to PCI DSS v3.0
= 0.09 (May 2013) =
* First version PCI DSS v2.0 (not published)

## == License ==
See LICENSE file 

## == Contact ==
David Acosta (admin[at]pcihispano.com)

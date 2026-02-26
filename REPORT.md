# **ZERO TIER LAB REPORT**
================================================================================================

This report documents the process of creating a Virtual Local Area Network (VLAN) 
using ZeroTier to connect multiple machines located across different physical hosts 
and network segments. The goal was to build a unified lab environment where a Windows Server 2025 
and two virtual machines could communicate as if they were on the same Layer‑2 network.
ZeroTier was selected because it provides a lightweight, software‑defined networking solution 
that creates encrypted, peer‑to‑peer virtual networks with minimal configuration.


------------------------------------------------------------------------------------------------
## **ENVIRONMENT OVERVIEV**
**------------------------------------------------------------------------------------------------**
### PHYSICAL LAYOUT

- Machine A: Physical host running Windows Server 2025

- Machine B: Physical host running multiple VMs

- Router: Segments the two physical hosts into different subnets

- Goal: Make all machines appear on the same LAN

------------------------------------------------------------------------------------------------  
### VIRTUAL MACHINES ORACLE VIRTUAL BOX
**------------------------------------------------------------------------------------------------**
- VM1 (OS: Windows 11 Enterprise) **x2**

- VM2 (OS:Windows 2025 Server)

------------------------------------------------------------------------------------------------    
## ZEROTIER ONE NETWORK SETUP
**------------------------------------------------------------------------------------------------**
### CREATING ZEROTIER ONE NETWORK

A new virtual network was created using the ZeroTier web console:

- Logged into https://my.zerotier.com

- Created a new private network

- Obtained the Network ID

- Enabled automatic IP assignment (default 10.x.x.x range)

- This network acts as the virtual VLAN for all lab machines.


------------------------------------------------------------------------------------------------
## **INSTALLATION AND CONFIGURATION**
**------------------------------------------------------------------------------------------------**
### INSTALLING ZEROTIER

ZeroTier was installed on:

- Windows Server 2025

- VM1

- VM2

The installation process was straightforward on the VMs, but the Windows Server required 
additional troubleshooting due to driver‑signing restrictions.

------------------------------------------------------------------------------------------------
### JOINING THE NETWORK

Each machine joined the ZeroTier network using:
**Powershell**

`zerotier-cli join <network-id>`

On Windows Server, the ZeroTier client appeared in the system tray and allowed joining through the GUI.


------------------------------------------------------------------------------------------------
### TROUBLESHOOTING ON WINDOWS SERVER 2025
During installation on Windows Server 2025, ZeroTier initially failed to launch. Investigation revealed:

- The installation folder existed but lacked the TAP driver files.

- No ZeroTier service was registered.

- No driver was installed.

This indicated that Windows Server silently blocked the driver installation.


------------------------------------------------------------------------------------------------
### DIAGNOSTIC COMMANDS USED

A series of PowerShell commands were used to diagnose the issue:

- Service and driver checks

`Get-Service -Name zerotierone`
`pnputil /enum-drivers | findstr ZeroTier`

- Testsigning mode

`bcdedit /set testsigning on`

- Secure Boot status

`Confirm-SecureBootUEFI`

- Event logs

`Get-WinEvent -LogName Setup -MaxEvents 50 | findstr /i "ZeroTier"`

- Firewall rules

`Get-NetFirewallRule | findstr ZeroTier`

------------------------------------------------------------------------------------------------
### RESOLUTION

The issue was resolved by:

- Ensuring testsigning mode was enabled

- Verifying Memory Integrity was disabled

- Confirming the ZeroTier client was already running in the system tray

Once the client was opened, the server successfully joined the network.


------------------------------------------------------------------------------------------------
## **VERIFICATION**
**------------------------------------------------------------------------------------------------**
### CONNECTIVITY TESTS

Each machine was assigned a ZeroTier virtual IP address. Connectivity was verified using:

**Powershell**
`ping <zerotier-ip>`

All machines were able to communicate across the virtual LAN.


------------------------------------------------------------------------------------------------
### NETWORK VISIBILITY

The ZeroTier web console confirmed:

- All devices were authorized

- All devices were online

- All devices had valid virtual IPs


------------------------------------------------------------------------------------------------
## **CONCLUSION**
------------------------------------------------------------------------------------------------
The VLAN was successfully formed using ZeroTier, enabling seamless communication 
between physically separated machines. The project demonstrated:

- How ZeroTier simplifies cross‑network connectivity

- How to troubleshoot driver‑related issues on Windows Server 2025

- How to verify and validate a virtual network configuration

**This setup now serves as a flexible foundation for further lab development, testing, and experimentation.**







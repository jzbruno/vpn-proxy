# VPN Proxy VM

## Overview

This repo contains automation and instructions for running a light VM for proxying traffic for 
specific web sites through your VPN isolated on the VM. This helps avoid issues when connecting to 
public web sites that have issues on a VPN when you only need to use one or two sites on the VPN.

## Requirements

* Canonical Multipass
* Hostess
* Jq
* Proxy browser plugin (for example, FoxyProxy)

## Setup

1. Install requirements

    ```bash
    brew install multipass
    brew install hostess
    brew install jq
    ```

2. Edit the vpn.env file to include your VPN URL, username and password. (we could update this to 
pull from the MacOS keychain)

3. Launch the VM. Once the VM is running your VIPAccess application will prompt you to approve the 
connection. This will also update your /etc/hosts file to include an entry for vpn.local.

    ```bash
    ./launch 
    ```

4. Setup your proxy to point to host = vpn.local and port = 8888. An example file for FoxyProxy can 
be found at foxproxy.json

## Operations

You can stop the VM

```bash
multipass stop vpn
```

You can start the VM. This will cause VIPAccess to prompt for approval again.

```bash
multipass stop vpn
```

You can get rid the VM. If you don't run purge, the VM can be recovered.

```bash
multipass delete vpn
multipass purge
```

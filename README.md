# synology-guestshares
Shell script using bind mounts to enable subdirectory sharing with another account in Synology DSM

As of Synology DSM 6.1.3, users are unable to control which subdirectories of a share can be viewed by an account. For example, user "guest" can be given read permissions to `/volume1/a` but not directly `/volume1/a/b/c`. This can be circumvented by mounting subdirectories as bind mounts into a secondary share your guest user has appropriate permissions for.

# Requirements
  - Dataset containing a directory or subdirectory that you want to provide a guest
  - Share your guest user has permissions for, `guestshare` for purposes of this script (Control Panel > Shared Folder > Create)
  - SSH enabled via DSM (Control Panel > Terminal & SNMP > Enable SSH service checkbox)
  
# Usage
1. Copy script to usable location on the Synology
2. Set `guestshare` and `mountlist` vars at the top of the script to the appropriate names of your shares
3. Open SSH session and su to root (`sudo su -`)
4. Add share(s) for guest. This will write the full path to `$mountlist` and the bind mount will now be visible.
  - `# guestshares.sh addshare /volume1/data/Photos "/volume1/data/a/b c"`
5. Setup triggered tasks in DSM for mounting/unmounting on boot and shutdown. (Control Panel > Task Scheduler > Create > Triggered Task > User-defined script)
  - Set event to `Boot-up` and User-defined script to `/path/to/guestshares.sh mount`
  - Set event to `Shutdown` and User-defined script to `/path/to/guestshares.sh unmount`

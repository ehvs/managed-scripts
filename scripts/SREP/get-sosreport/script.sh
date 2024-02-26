#!/bin/bash

set -e
set -o nounset
set -o pipefail

# Import sftp_upload library
#base64 -d <<< IyEvYmluL2Jhc2gKIyBEZXNjcmlwdGlvbjogcHJvdmlkZSB0aGUgc2Z0cF91cGxvYWQgZnVuY3Rpb24gZm9yIHNjcmlwdCB0byBjYWxsCiMKIyBUbyBpbXBvcnQgdGhlIHNmdHBfdXBsb2FkIGZ1bmN0aW9uLAojIGluY2x1ZGUgaW4geW91ciBzY3JpcHQgd2l0aAojIHNvdXJjZSAvbWFuYWdlZC1zY3JpcHRzL2xpYi9zZnRwX3VwbG9hZC9saWIuc2gKCiMgRmFpbCBmYXN0IGFuZCBiZSBhd2FyZSBvZiBleGl0IGNvZGVzCnNldCAtZXVvIHBpcGVmYWlsCgojIENvbnN0YW50cwpyZWFkb25seSBGVFBfSE9TVD0ic2Z0cC5hY2Nlc3MucmVkaGF0LmNvbSIKcmVhZG9ubHkgU0ZUUF9PUFRJT05TPSgtbyBCYXRjaE1vZGU9bm8gLWIpCnJlYWRvbmx5IEtOT1dOX0hPU1Q9J3NmdHAuYWNjZXNzLnJlZGhhdC5jb20sMzUuODAuMjQ1LjEgc3NoLXJzYSBBQUFBQjNOemFDMXljMkVBQUFBREFRQUJBQUFCQVFDRlEzbDJZVkowcjRNTnpBWm1UVjJrZzdyUGk0V1BlSk5jTnVidk9WQTRXd0JWNmNSc1lGa0lxdEIxdW5CelRYb1pIZDcrYWR0WlRnVXJKMkJFeElteUxVUWFMQnUzS0tvNENnR2VpWk1vOGRmRHZFMnRJZS9Hd0d0eWhvNTdUdHdKVlZVQ2xqdkZCdmJ6OCtENlZ1bnNRNmtOVTUzdDhxQ2FCUU5tNjF0d1RrZEFIUDlJRVNKYkM3d1dKcWptaG1PTVRhdjFPS1FEdExFc1NEYzRJK3MraDQxTHZVZncxbEE3UlNsOWVSMTNUSzl5U3BOL3VXNW5CcTduVU5XVzVPQmMzVWJ2cGRRcERYdmRVRGJXMHJRMkVFV3ZMa0t1YmhrK1JTZVkvbEg4cGVPZUhZUTVBUlBZZkZEcG81S3NLRERkS2E5RGZuSzhOOEFQZ3R6TTByK2wnCgojIyBVcGxvYWQgYSBmaWxlIHRvIHNmdHAuYWNjZXNzLnJlZGhhdC5jb20gdXNpbmcgdGhlIHVuYXV0aGVudGljYXRlZCBmbG93LgojIyBNb3JlIGFib3V0IHRoZSBTRlRQIHNlcnZlcjoKIyMgaHR0cHM6Ly9hY2Nlc3MucmVkaGF0LmNvbS9hcnRpY2xlcy81NTk0NDgxCiMjCiMjIFVzYWdlOiBzZnRwX3VwbG9hZCA8c291cmNlLWZpbGVuYW1lPiA8ZGVzdGluYXRpb24tZmlsZW5hbWU+CiMjIEV4bWFwbGU6IHNmdHBfdXBsb2FkICR7UFdEfS9tdXN0LWdhdGhlci50YXIuZ3ogbXVzdC1nYXRoZXIudGFyLmd6CiMjIFRoZSA8ZGVzdGluYXRpb24tZmlsZW5hbWU+IHNob3VsZCBiZSBhIGZpbGVuYW1lIG5vdCBhIHBhdGguCmZ1bmN0aW9uIHNmdHBfdXBsb2FkKCkgewogICAgIyMgU2V0IHVwIGtub3duIGhvc3RzIGZpbGUKICAgIG1rZGlyIC1wICIke0hPTUV9Ly5zc2giCiAgICBjaG1vZCA3MDAgIiR7SE9NRX0vLnNzaCIKICAgIGVjaG8gIiR7S05PV05fSE9TVH0iID4gIiR7SE9NRX0vLnNzaC9rbm93bl9ob3N0cyIKCiAgICAjIyBHZXQgYSBvbmUtdGltZSB1cGxvYWQgdG9rZW4KICAgIGNyZWRzPSQoY3VybCAtLXJlcXVlc3QgUE9TVCAnaHR0cHM6Ly9hY2Nlc3MucmVkaGF0LmNvbS9oeWRyYS9yZXN0L3YyL3NmdHAvdG9rZW4nIFwKICAgIC0taGVhZGVyICdDb250ZW50LVR5cGU6IGFwcGxpY2F0aW9uL2pzb24nIFwKICAgIC0tZGF0YS1yYXcgJ3sKICAgICJpc0Fub255bW91cyIgOiB0cnVlCiAgICB9JykKICAgIHVzZXJuYW1lPSQoanEgLXIgJy51c2VybmFtZScgPDw8ICIke2NyZWRzfSIpCiAgICB0b2tlbj0kKGpxIC1yICcudG9rZW4nIDw8PCAiJHtjcmVkc30iKQoKICAgICMjIFVwbG9hZCB0aGUgZmlsZQogICAgc3NocGFzcyAtcCAiJHt0b2tlbn0iIHNmdHAgIiR7U0ZUUF9PUFRJT05TW0BdfSIgLSAiJHt1c2VybmFtZX0iQCIke0ZUUF9IT1NUfSIgPDwgRU9TU0hQQVNTCiAgICAgICAgcHV0ICQxICQyCiAgICAgICAgYnllCkVPU1NIUEFTUwogICAgIyBjb252ZXJ0IHRoZSB1c2VybmFtZSB0byBsb3dlcmNhc2UgZm9yIGVhc2Ugb2YgY29weSAvIHBhc3RlCiAgICBsb3dlcl9jYXNlX3VzZXJuYW1lPSQodHIgJ1s6dXBwZXI6XScgJ1s6bG93ZXI6XScgPDw8ICIke3VzZXJuYW1lfSIpCgogICAgZWNobyAiVXBsb2FkZWQgZmlsZSAkMSB0byAke0ZUUF9IT1NUfSwgQW5vbnltb3VzIHVzZXJuYW1lOiAke2xvd2VyX2Nhc2VfdXNlcm5hbWV9LCBmaWxlbmFtZTogJDIiCiAgICBlY2hvICJGb3IgbW9yZSBpbmZvcm1hdGlvbiBhYm91dCBTRlRQOiBodHRwczovL2FjY2Vzcy5yZWRoYXQuY29tL2FydGljbGVzLzU1OTQ0ODEiCiAgICByZXR1cm4gMAp9Cg==  > /tmp/lib.sh

# source /tmp/lib.sh

## validate input
if [[ -z "$NODE" ]]
then
    echo "Variable node cannot be blank"
    exit 1
fi


# Define expected values
DUMP_DIR="/tmp"
DATE="$(date -u +"%Y%m%dT%H%M")"

check_node(){
    echo "Checking if \"${NODE}\" is an existing node..."
    
    if (oc get nodes --no-headers -oname | grep "${NODE}") &> /dev/null; then
       echo "[OK] \"${NODE}\" is a node."
    else
        echo "[Error] \"${NODE}\" is not a node. Exiting script"
        exit 1
    fi
}

generate_sosreport() {
# 1st Debug session - Generate the sosreport and keep it in the host

    echo " ==== Generating SOSREPORT ===="
    oc -n default debug node/"${NODE}" -- sh -c "chroot /host toolbox sos report -k crio.all=on -k crio.logs=on --batch"

    return 0
}

validate_file() {
    echo "==== Check if the sosreport is created inside the node ===="
    oc -n default debug node/"${NODE}" -- bash -c "ls -l /host/var/tmp/*.tar.xz" | tee;

    return 0
}

copy_sosreport() {
# 2nd Debug session - Fetch sosreport .tar.xz file and save inside the container volume.
# It is used the VARS UNIQ_SOS_FULLPATH and UNIQ_SOS_FILENAME to make sure that along the script, a unique file will be touched even if other sosreport files exists in the node.
    echo "==== Copying file to container ===="
    UNIQ_SOS_FULLPATH="$(oc -n default debug node/"${NODE}" -- bash -c "ls -Art1 /host/var/tmp/sosreport-*.tar.xz | tail -1")";
    UNIQ_SOS_FILENAME="${UNIQ_SOS_FULLPATH//\/host\/var\/tmp\//}"
    oc -n default debug node/"${NODE}" -- bash -c "ls -l ${UNIQ_SOS_FULLPATH}; cat ${UNIQ_SOS_FULLPATH}" > "${DUMP_DIR}/${UNIQ_SOS_FILENAME}";

    return 0
}

validate_file_in_container() {
    echo "==== Check if file exists inside container ===="
    ls -la "${DUMP_DIR}"/"${UNIQ_SOS_FILENAME}"
    return 0
}

delete_sosreport_from_node() {
# Deleting any sosreport from the /host/var/tmp inside node

    echo "==== Deleting only the sosreport assigned to variable UNIQ_SOS_FULLPATH from inside the node ===="
    echo "UNIQ_SOS_FULLPATH is ===> ${UNIQ_SOS_FULLPATH}"
    oc -n default debug node/"${NODE}" -- sh -c "rm $UNIQ_SOS_FULLPATH && rm $UNIQ_SOS_FULLPATH.sha256 && ls -l /host/var/tmp/"
    echo "==== SOSREPORT file should be now not showing in the list above ===="

    return 0
}

# Function to upload the tarball to SFTP
upload_sosreport() {
  cd "${DUMP_DIR}"
  
  echo "==== Uploading SOSREPORT to SFTP server ===="
  # Check if the tarball is in place
  if [ ! -f "${DUMP_DIR}/${UNIQ_SOS_FILENAME}" ]; then
    echo "Sosreport file is not found in ${DUMP_DIR}/${UNIQ_SOS_FILENAME}"
    exit 1
  fi

  sftp_upload "${DUMP_DIR}/${UNIQ_SOS_FILENAME}" "${DATE}-${UNIQ_SOS_FILENAME}"

  return 0
}

main() {
    check_node
    generate_sosreport
    validate_file
    copy_sosreport
    validate_file_in_container
    delete_sosreport_from_node
    upload_sosreport 
    echo "sosreport process completed successfully"
  }
    
# Execute main function
main
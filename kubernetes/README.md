
```
export NIFCLOUD_ACCESS_KEY_ID=<YOUR ACCESS KEY>
export NIFCLOUD_SECRET_ACCESS_KEY=<YOUR SECRET ACCESS KEY>
export SSHKEY=<SSH KEY NAME>
```

```
KUBESPRAY_VERSION=v2.22.0
export CLUSTER_INFO_FILE=ansible/extra-vars.yml
export BASTION_IP=$(cat ${CLUSTER_INFO_FILE} | grep bn | grep pub | grep w | cut -d ' ' -f 2)
export ANSIBLE_SSH_ARGS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand=\"ssh root@${BASTION_IP} -W %h:%p\""
```

```
eval `ssh-agent`
ssh-add ${SSHKEY}
```

```
ansible-galaxy install -r ansible/requirements.yml
```
```
ansible-playbook -i ansible/inventory/inventory.ini -e @ansible/extra-vars.yml ansible/playbook/setup_proxy.yml
```

```
docker run --rm -it -e ANSIBLE_SSH_ARGS -e CLUSTER_INFO_FILE --mount type=bind,source="${SSHKEY}",dst=/.ssh/key --mount type=bind,source="$(pwd)",dst=/wd quay.io/kubespray/kubespray:${KUBESPRAY_VERSION} bash
```

```
cp -r /wd/ansible/playbook/kubespray/playbooks .
export ANSIBLE_ROLES_PATH=$(pwd)/roles
export ANSIBLE_LIBRARY=/wd/ansible/playbook/kubespray/plugins/modules
eval `ssh-agent`
ssh-add /.ssh/key
```

```
ansible-playbook -i /wd/ansible/inventory/inventory.ini -e @/wd/${CLUSTER_INFO_FILE}  cluster.yml
```

```
cp /wd/ansible/setup_bastion.yml .
ansible-playbook -i /wd/ansible/inventory/inventory.ini -e @/wd/${CLUSTER_INFO_FILE} setup_bastion.yml
```

```
ansible-playbook -i /wd/ansible/inventory/inventory.ini -e @/wd/${CLUSTER_INFO_FILE}
```

```
go install github.com/vmware-tanzu/sonobuoy@latest
sonobuoy run --mode=certified-conformance
sonobuoy status
```

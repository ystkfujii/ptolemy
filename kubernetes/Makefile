EXTRA_VARS_FILE := "ansible/extra-vars.yml"

.PHONY: generate
generate:
	echo "# Code generated by terraform output, DO NOT EDIT." > ${EXTRA_VARS_FILE}
	echo "---" >> ${EXTRA_VARS_FILE}
	echo "# --- east ---" >> ${EXTRA_VARS_FILE}
	echo "# public_ip"  >> ${EXTRA_VARS_FILE}
	terraform -chdir=terraform output -json | jq -r -c '.k8s_infra_west.value.bastion_info| to_entries[]        | .key + "_public: " + .value.public_ip' >> ${EXTRA_VARS_FILE}
	terraform -chdir=terraform output -json | jq -r -c '.k8s_infra_west.value.control_plane_info | to_entries[] | .key + "_public: " + .value.public_ip' >> ${EXTRA_VARS_FILE}
	terraform -chdir=terraform output -json | jq -r -c '.k8s_infra_west.value.worker_info | to_entries[]        | .key + "_public: " + .value.public_ip' >> ${EXTRA_VARS_FILE}
	terraform -chdir=terraform output -json | jq -r -c '.k8s_infra_west.value.proxy_info | to_entries[]         | .key + "_public: " + .value.public_ip' >> ${EXTRA_VARS_FILE}
	echo "# private_ip" >> ${EXTRA_VARS_FILE}
	terraform -chdir=terraform output -json | jq -r -c '.k8s_infra_west.value.bastion_info| to_entries[]        | .key + "_private: " + .value.private_ip' >> ${EXTRA_VARS_FILE}
	terraform -chdir=terraform output -json | jq -r -c '.k8s_infra_west.value.control_plane_info | to_entries[] | .key + "_private: " + .value.private_ip' >> ${EXTRA_VARS_FILE}
	terraform -chdir=terraform output -json | jq -r -c '.k8s_infra_west.value.worker_info | to_entries[]        | .key + "_private: " + .value.private_ip' >> ${EXTRA_VARS_FILE}
	terraform -chdir=terraform output -json | jq -r -c '.k8s_infra_west.value.proxy_info | to_entries[]         | .key + "_private: " + .value.private_ip' >> ${EXTRA_VARS_FILE}

	echo "# --- west ---" >> ${EXTRA_VARS_FILE}
	echo "# public_ip"  >> ${EXTRA_VARS_FILE}
	terraform -chdir=terraform output -json | jq -r -c '.k8s_infra_east.value.bastion_info| to_entries[]        | .key + "_public: " + .value.public_ip' >> ${EXTRA_VARS_FILE}
	terraform -chdir=terraform output -json | jq -r -c '.k8s_infra_east.value.control_plane_info | to_entries[] | .key + "_public: " + .value.public_ip' >> ${EXTRA_VARS_FILE}
	terraform -chdir=terraform output -json | jq -r -c '.k8s_infra_east.value.worker_info | to_entries[]        | .key + "_public: " + .value.public_ip' >> ${EXTRA_VARS_FILE}
	terraform -chdir=terraform output -json | jq -r -c '.k8s_infra_east.value.proxy_info | to_entries[]         | .key + "_public: " + .value.public_ip' >> ${EXTRA_VARS_FILE}
	echo "# private_ip" >> ${EXTRA_VARS_FILE}
	terraform -chdir=terraform output -json | jq -r -c '.k8s_infra_east.value.bastion_info| to_entries[]        | .key + "_private: " + .value.private_ip' >> ${EXTRA_VARS_FILE}
	terraform -chdir=terraform output -json | jq -r -c '.k8s_infra_east.value.control_plane_info | to_entries[] | .key + "_private: " + .value.private_ip' >> ${EXTRA_VARS_FILE}
	terraform -chdir=terraform output -json | jq -r -c '.k8s_infra_east.value.worker_info | to_entries[]        | .key + "_private: " + .value.private_ip' >> ${EXTRA_VARS_FILE}
	terraform -chdir=terraform output -json | jq -r -c '.k8s_infra_east.value.proxy_info | to_entries[]         | .key + "_private: " + .value.private_ip' >> ${EXTRA_VARS_FILE}

.PHONY: terraform-init
terraform-init:
	terraform -chdir=terraform init

.PHONY: terraform-apply
terraform-apply: terraform-init
	terraform -chdir=terraform apply -auto-approve

.PHONY: terraform-plan
terraform-plan: terraform-init
	terraform -chdir=terraform plan

.PHONY: terraform-destroy
terraform-destroy: terraform-init
	terraform -chdir=terraform destroy -auto-approve

.PHONY: terraform-output
terraform-output: terraform-init
	terraform -chdir=terraform output


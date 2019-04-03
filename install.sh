#! /bin/bash

IMAGE_FAMILY_GPU="tf-latest-gpu"
IMAGE_FAMILY_CPU="tf-latest-cpu"
ZONE="us-west1-b"
INSTANCE_NAME="cloud-notebook"

read -p "Have you increased your quota for 'nvidia-tesla-v100' in $ZONE [y/n]:" YES
create_gpu_instance()
{
	gcloud compute instances create $INSTANCE_NAME \
		--zone=$ZONE \
		--image-family=$IMAGE_FAMILY_GPU \
		--image-project=deeplearning-platform-release \
		--boot-disk-size=56GB \
		--maintenance-policy=TERMINATE \
		--accelerator="type=nvidia-tesla-v100,count=1" \
		--metadata="install-nvidia-driver=True" \
		--tags=http-server \
		--address=jupyter-cloudbook \
		--metadata-from-file=startup-script=start_docker_gpu.sh
}

create_cpu_instance()
{
	gcloud compute instances create $INSTANCE_NAME \
		--zone=$ZONE \
		--image-family=$IMAGE_FAMILY_CPU \
		--image-project=deeplearning-platform-release \
		--boot-disk-size=56GB \
		--maintenance-policy=TERMINATE \
		--tags=http-server \
		--address=jupyter-cloudbook \
		--metadata-from-file=startup-script=start_docker_cpu.sh
}

if [ "$YES" = "n" ]
then
	echo "Use this link to add 'nvidia-tesla-v100'"
	echo "https://cloud.google.com/compute/docs/gpus/add-gpus"
else
	# Install GCLOUD
	echo "Installing gcloud"
	sleep 3
	# Create environment variable for correct distribution
	export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"

	# Add the Cloud SDK distribution URI as a package source
	echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

	# Import the Google Cloud Platform public key
	curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

	# Update the package list and install the Cloud SDK
	sudo apt-get update && sudo apt-get install google-cloud-sdk

	# Create an deep learning VM on gcloud

	gcloud compute addresses create jupyter-cloudbook \
		--zone=$ZONE

	if [ "$GPU" = "y" ]
	then
		create_gpu_instance
	else
		create_cpu_instance
	fi

	echo "put the corresponding IP address for 'jupyter-cloudbook' into your browser"
	echo "Your password will be 'temporaryBridge'"
	echo "CHANGE IT IMMEDIATELY!"

	gcloud compute addresses list
fi
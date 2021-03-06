# Cloud-Notebook (ALPHA)

All the power of a machine learning setup without the cost and the overhead of setting up your own machine.

## Unix/Linux instructions
1. Run "install.sh" in your terminal
2. Follow the instructions to navigate to your jupyter notebook in the cloud
3. Add ```GPU=n``` for a cheaper CPU based instance.

## How it works
1. Installs gcloud
2. Creates a named static IP address
3. Creates a deep learning ready [instance](https://cloud.google.com/deep-learning-vm/docs/cli)
4. Initialize it with a startup script that installs docker and launches a [tensorflow/jupyter capable vm](https://hub.docker.com/r/jupyter/tensorflow-notebook)
5. A temporary password is set to prevent arbitrary execution of code your now public jupyter server


## Running locally
run either of the start docker images in your bash command line
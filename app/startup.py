#! /usr/bin/python3
from pathlib import Path
import re
import subprocess as sp

"""
Assumes installation on Linux system
"""

JUPYTER_CONFIG = str(Path.home()) + "/.jupyter/jupyter_notebook_config.py"
PORT_NUMBER = 8888

def check_installed(file_name):
	try:
		sp.check_output(["which", file_name])
		return True
	except sp.CalledProcessError:
		return False

re_subs = [(re.compile("c.NotebookApp.ip =.*"), "c.NotebookApp.ip = '*'"),
	(re.compile("c.NotebookApp.open_browser =.*"), "c.NotebookApp.open_browser = False"),
	(re.compile("c.NotebookApp.port =.*"), "c.NotebookApp.port = {}".format(PORT_NUMBER))]

def edit_jupyter():
	file_lines = None
	with open(JUPYTER_CONFIG, "r") as old:
		file_lines = old.readlines()

	for i in range(len(file_lines)):
		for regex, substitution in re_subs:
			file_lines[i] = regex.sub(substitution, file_lines[i])

	with open(JUPYTER_CONFIG, "w") as new_file:
		new_file.writelines(file_lines)

def launch_notebook():
	if not check_installed("jupyter"):
		sp.run(["conda", "install", "jupyter"])
		
	try:
		sp.check_output(["ls", JUPYTER_CONFIG])
	except sp.CalledProcessError:
		sp.run(["jupyter", "notebook", "--generate-config"])
		edit_jupyter()
		sp.run(["jupyter-notebook", "--no-browser", "--port={}".format(PORT_NUMBER)])

if __name__ == '__main__':
	launch_notebook()
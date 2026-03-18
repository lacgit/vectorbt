


docker run --user root -d -p 8889:8888 -v $HOME/Projects/JupyterProjects:/home/jovyan/work -v $HOME/Projects/JupyterProjects/.cache:/home/jovyan/.cache -e NB_UID=1001 -e NB_GID=1001 -e JUPYTER_ENABLE_LAB=yes -e JUPYTER_TOKEN="818d911282226023cc2a7a050709e19e7b9c0421a9bec6d6" --name vectorbt vectorbt


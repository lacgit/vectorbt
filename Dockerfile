ARG BASE_IMAGE=quay.io/jupyter/scipy-notebook:latest
FROM ${BASE_IMAGE} AS vectorbt

LABEL org.opencontainers.image.title="vectorbt"
LABEL org.opencontainers.image.description="VectorBT in Jupyter"
LABEL org.opencontainers.image.source="https://github.com/polakowo/vectorbt"

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
      git \
	  gnupg gnupg1 gnupg2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*


USER ${NB_UID}
WORKDIR /home/${NB_USER}/work

ARG VBT_EXTRAS=""

COPY --chown=${NB_UID}:${NB_GID} . /tmp/vectorbt


RUN python -m pip install kaleido \
		yfinance backtrader pyportfolioopt python-binance ccxt \
		aiohttp TA-Lib python-telegram-bot \
    && python -m pip install --no-cache-dir -U pip setuptools wheel \
    && python -m pip install --no-cache-dir "/tmp/vectorbt${VBT_EXTRAS:+[${VBT_EXTRAS}]}" \
    && rm -rf /tmp/vectorbt


ENV NUMBA_CACHE_DIR=/home/jovyan/.cache


EXPOSE 8888

CMD ["start-notebook.py", "--ServerApp.ip=0.0.0.0", "--ServerApp.port=8888"]

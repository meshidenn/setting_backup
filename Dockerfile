FROM horovod/horovod:0.18.1-tf1.14.0-torch1.2.0-mxnet1.5.0-py3.6

SHELL ["/bin/bash", "-cu"]
RUN apt-get update -y
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:kelleyk/emacs
RUN apt-get update -y

RUN apt-get install -y --allow-downgrades --allow-change-held-packages --no-install-recommends \
    emacs25

ENV HOME /home
WORKDIR $HOME/

## python library
RUN pip install pandas sklearn tqdm gensim scipy

## tmuxの設定
RUN git clone git://github.com/meshidenn/setting_backup.git ${HOME}/setting_backup 
RUN cp ${HOME}/setting_backup/.tmux.conf ./

## emacsの設定
RUN curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python
ENV PATH=$HOME/.cask/bin:$PATH
RUN cask upgrade
RUN cp -r ${HOME}/setting_backup/.emacs.d ./
RUN cd ~/.emacs.d && cask install

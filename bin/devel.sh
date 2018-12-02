#!/bin/sh


export BIN_DIR=`dirname $0`
export PROJECT_ROOT=`readlink -f "${BIN_DIR}/.."`


if [ -f /usr/local/bin/cbsd ]; then
  if [ ! -e "${PROJECT_ROOT}/services/frontend/project.conf" ]; then
    backend_hostname=$(sudo cbsd jexec user=devel jname=pyserback hostname)
    echo "HTTP_PROXY=http://${backend_hostname}:5000" >"${PROJECT_ROOT}/services/frontend/project.conf"
  fi
  sudo cbsd jexec user=devel jname=pyserback /usr/src/bin/default_user.sh
  sudo tmux new-session -s "tilda" -d "cbsd jexec user=devel jname=pyserback /usr/src/bin/devel.sh"
  sudo tmux split-window -h -p 50 -t 0 "cbsd jexec user=devel jname=pyserfront /usr/src/bin/devel.sh"
  sudo tmux a
else
  if [ ! -e "${PROJECT_ROOT}/services/frontend/project.conf" ]; then
    backend_hostname='localhost:5000'
    echo "HTTP_PROXY=http://${backend_hostname}:5000" >"${PROJECT_ROOT}/services/frontend/project.conf"
  fi
  "${PROJECT_ROOT}/bin/download_repos.sh"
  "${PROJECT_ROOT}/services/backend/bin/default_user.sh"
  tmux new-session -s "tilda" -d "${PROJECT_ROOT}/services/backend/bin/devel.sh"
  tmux split-window -h -p 50 -t 0 "${PROJECT_ROOT}/services/frontend/bin/devel.sh"
  tmux a
fi

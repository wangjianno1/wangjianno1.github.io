#!/bin/bash
#######################################################
##  Desc: 提交blog到github仓库并部署到hexo菜园子     ##
##  Date: 2021-03-22                                 ##
#######################################################

##########Step1:提交变更到Github仓库##############
#git add -A
#git commit -m "update"
#git push origin hexo

##########Step2:部署内容到hexo站点################
hexo clean
hexo generate
hexo server

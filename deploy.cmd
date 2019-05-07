@echo off
set deploy=.deploy_git

if exist %deploy% (
    rmdir /s/q %deploy%
)

hexo clean && hexo g && hexo d
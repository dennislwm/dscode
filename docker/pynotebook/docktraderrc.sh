alias dib='docker image build -t pynotebook .'
alias dcb='docker run -v d:/docker/pynotebook:/home:rw --name objPynotebook -e DISPLAY=10.0.75.1:0.0 -p 8888:8888 -it pynotebook bash'
#
# cannot be used with docker-compose
alias dcr='docker run -v d:/docker/pynotebook:/home:rw --name objPynotebook -e DISPLAY=10.0.75.1:0.0 -p 8888:8888 -it pynotebook'
alias dcs='docker start -ia objPynotebook'
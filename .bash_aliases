#for getting a single server
alias server="python -m SimpleHTTPServer $1"
alias servephp="php -S 0.0.0.0:8000 -t ."

#for docker
function remove_exited_containers(){
    for exited in $(docker ps -af status=exited)
    do
        docker rm $exited
    done
}

function remove_all_containers(){
    for container in $(docker ps -a)
    do
        docker stop $container
        docker rm $container
    done
}

function remove_untagged_images(){
  docker rmi $(docker images | grep "^<none>" | awk "{print $3}")
}
#source: https://gist.github.com/mario21ic/9bb00b6f1fceb1c1a016

#for git
function current_branch() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo ${ref#refs/heads/}
}

function gpull() {
    echo "git pull origin $(current_branch)"
    git pull origin $(current_branch)
}

function gpush() {
    echo "git push origin $(current_branch):$(current_branch)"
    git push origin $(current_branch):$(current_branch)
}
alias gst='git status'
alias gacm='git add .;git commit -am'
alias gco='git checkout'
alias gpo='git pull origin'
alias gps='git push origin'

#Who listen?
function pslisten {
    echo `lsof -n -i4TCP:$1 | grep LISTEN`
}
alias removeorig='find . -regex ".*\.\orig" -delete'

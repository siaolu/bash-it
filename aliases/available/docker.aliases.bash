# shellcheck shell=bash

# Logging functions
function log_operation() {
  local operation=$1
  echo "$(date '+%Y-%m-%d %H:%M:%S') - Operation: $operation" >> $LOG_FILE
}

function log_execution_time() {
  local function_name=$1
  local start_time=$2
  local end_time=$(date +%s)
  local execution_time=$((end_time - start_time))
  echo "$(date '+%Y-%m-%d %H:%M:%S') - Function: $function_name, Execution Time: $execution_time seconds" >> $LOG_FILE
}

# Docker abbreviations
alias dk='docker'
alias dklc='docker ps -l' # List last Docker container
alias dklcid='docker ps -l -q' # List last Docker container ID
alias dklcip='docker inspect -f "{{.NetworkSettings.IPAddress}}" $(dklcid)' # Get IP of last Docker container
alias dkps='docker ps' # List running Docker containers
alias dkpsa='docker ps -a' # List all Docker containers
alias dki='docker images' # List Docker images
alias dkrmac='docker rm $(docker ps -a -q)' # Delete all Docker containers

case $OSTYPE in
  darwin* | _bsd_ | _BSD_)
    alias dkrmui='docker images -q -f dangling=true | xargs docker rmi' # Delete all untagged Docker images
    ;;
  *)
    alias dkrmui='docker images -q -f dangling=true | xargs -r docker rmi' # Delete all untagged Docker images
    ;;
esac

alias dkelc='docker exec -it $(dklcid) bash --login' # Enter last container (works with Docker 1.3 and above)
alias dkrmflast='docker rm -f $(dklcid)' # Delete most recent (i.e., last) Docker container
alias dkbash='dkelc'
alias dkex='docker exec -it $(dklcid)' # Useful to run any commands into container without leaving host
alias dkri='docker run --rm -i'
alias dkric='docker run --rm -i -v $PWD:/cwd -w /cwd'
alias dkrit='docker run --rm -it'
alias dkritc='docker run --rm -it -v $PWD:/cwd -w /cwd'

# Added more recent cleanup options from newer docker versions
alias dkip='docker image prune -a -f'
alias dkvp='docker volume prune -f'
alias dksp='docker system prune -a -f'

# Additional commands with new alias naming convention
alias dkbl='dbuild' # Build Docker image
alias dkrn='drun' # Run Docker container
alias dkst='dstop' # Stop Docker container
alias dkrm='drm' # Remove Docker container
alias dkre='drestart' # Restart Docker container
alias dkfl='dflush' # Flush Docker environment
alias dklg='dlogs' # Fetch container logs
alias dknl='dnetwork_ls' # List Docker networks
alias dkvl='dvolume_ls' # List Docker volumes
alias dkup='dcompose_up' # Start Docker Compose
alias dkpl='dpull' # Pull Docker image
alias dkph='dpush' # Push Docker image
alias dksl='dsave' # Save Docker image
alias dkin='dinspect' # Inspect Docker object
alias dklo='dlogin' # Log in to Docker registry
alias dkou='dlogout' # Log out from Docker registry
alias dknc='dnetwork_create' # Create Docker network
alias dknn='dnetwork_connect' # Connect container to network
alias dknd='dnetwork_disconnect' # Disconnect container from network
alias dkpa='dpause' # Pause Docker container
alias dkpo='dport' # List container ports
alias dkrn='drename' # Rename Docker container
alias dksr='dstats' # Show container stats

# Help function to list available Docker commands
function dkhelp() {
  echo "Available Docker commands:"
  echo "  dk         = docker"
  echo "  dklc       = docker ps -l"
  echo "  dklcid     = docker ps -l -q"
  echo "  dklcip     = docker inspect -f \"{{.NetworkSettings.IPAddress}}\" \$(dklcid)"
  echo "  dkps       = docker ps"
  echo "  dkpsa      = docker ps -a"
  echo "  dki        = docker images"
  echo "  dkrmac     = docker rm \$(docker ps -a -q)"
  echo "  dkrmui     = docker images -q -f dangling=true | xargs docker rmi"
  echo "  dkelc      = docker exec -it \$(dklcid) bash --login"
  echo "  dkrmflast  = docker rm -f \$(dklcid)"
  echo "  dkbash     = dkelc"
  echo "  dkex       = docker exec -it \$(dklcid)"
  echo "  dkri       = docker run --rm -i"
  echo "  dkric      = docker run --rm -i -v \$PWD:/cwd -w /cwd"
  echo "  dkrit      = docker run --rm -it"
  echo "  dkritc     = docker run --rm -it -v \$PWD:/cwd -w /cwd"
  echo "  dkip       = docker image prune -a -f"
  echo "  dkvp       = docker volume prune -f"
  echo "  dksp       = docker system prune -a -f"
  echo "  dkbl       = dbuild"
  echo "  dkrn       = drun"
  echo "  dkst       = dstop"
  echo "  dkrm       = drm"
  echo "  dkre       = drestart"
  echo "  dkfl       = dflush"
  echo "  dklg       = dlogs"
  echo "  dknl       = dnetwork_ls"
  echo "  dkvl       = dvolume_ls"
  echo "  dkup       = dcompose_up"
  echo "  dkpl       = dpull"
  echo "  dkph       = dpush"
  echo "  dksl       = dsave"
  echo "  dkin       = dinspect"
  echo "  dklo       = dlogin"
  echo "  dkou       = dlogout"
  echo "  dknc       = dnetwork_create"
  echo "  dknn       = dnetwork_connect"
  echo "  dknd       = dnetwork_disconnect"
  echo "  dkpa       = dpause"
  echo "  dkpo       = dport"
  echo "  dkrn       = drename"
  echo "  dksr       = dstats"
}

# Revised functions to use the most recent Docker container or image
function dbuild() {
  local start_time=$(date +%s)
  log_operation "Building Docker image"
  docker build -t $(dklcid) . || { echo "Docker build failed, exiting."; return 1; }
  log_operation "Docker image built successfully"
  log_execution_time "${FUNCNAME[0]}" $start_time
}

function drun() {
  local start_time=$(date +%s)
  log_operation "Running Docker container"
  docker run -it --name $(dklcid)-new $(dklcid) || { echo "Docker run failed, exiting."; return 1; }
  log_operation "Docker container exited"
  log_execution_time "${FUNCNAME[0]}" $start_time
}

function dstop() {
  local start_time=$(date +%s)
  log_operation "Stopping Docker container"
  docker stop $(dklcid) || { echo "Docker stop failed, exiting."; return 1; }
  log_operation "Docker container stopped"
  log_execution_time "${FUNCNAME[0]}" $start_time
}

function drm() {
  local start_time=$(date +%s)
  log_operation "Removing Docker container"
  docker rm $(dklcid) || { echo "Docker remove failed, exiting."; return 1; }
  log_operation "Docker container removed"
  log_execution_time "${FUNCNAME[0]}" $start_time
}

function drestart() {
  local start_time=$(date +%s)
  log_operation "Restarting Docker container"
  docker restart $(dklcid) || { echo "Docker restart failed, exiting."; return 1; }
  log_operation "Docker container restarted"
  log_execution_time "${FUNCNAME[0]}" $start_time
}

function dflush() {
  local start_time=$(date +%s)
  log_operation "Flushing Docker environment"
  docker rm $(docker ps -a -q) 2>/dev/null || true
  docker rmi $(docker images -q) 2>/dev/null || true
  log_operation "Docker environment flushed"
  log_execution_time "${FUNCNAME[0]}" $start_time
}

function dlogs() {
  local start_time=$(date +%s)
  log_operation "Fetching Docker container logs"
  docker logs $(dklcid)
  log_execution_time "${FUNCNAME[0]}" $start_time
}

function dnetwork_ls() {
  local start_time=$(date +%s)
  log_operation "Listing Docker networks"
  docker network ls
  log_execution_time "${FUNCNAME[0]}" $start_time
}

function dvolume_ls() {
  local start_time=$(date +%s)
  log_operation "Listing Docker volumes"
  docker volume ls
  log_execution_time "${FUNCNAME[0]}" $start_time
}

function dcompose_up() {
  local start_time=$(date +%s)
  log_operation "Starting Docker Compose"
  docker-compose up
  log_execution_time "${FUNCNAME[0]}" $start_time
}

function dpull() {
  local start_time=$(date +%s)
  log_operation "Pulling Docker image"
  docker pull $(dklcid)
  log_execution_time "${FUNCNAME[0]}" $start_time
}

function dpush() {
  local start_time=$(date +%s)
  log_operation "Pushing Docker image"
  docker push $(dklcid)
  log_execution_time "${FUNCNAME[0]}" $start_time
}

function dsave() {
  local start_time=$(date +%s)
  log_operation "Saving Docker image"
  docker save $(dklcid) -o $(dklcid).tar
  log_execution_time "${FUNCNAME[0]}" $start_time
}

function dinspect() {
  local start_time=$(date +%s)
  log_operation "Inspecting Docker object"
  docker inspect $(dklcid)
  log_execution_time "${FUNCNAME[0]}" $start_time
}

function dlogin() {
  local start_time=$(date +%s)
  log_operation "Logging in to Docker registry"
  docker login
  log_execution_time "${FUNCNAME[0]}" $start_time
}

function dlogout() {
  local start_time=$(date +%s)
  log_operation "Logging out from Docker registry"
  docker logout
  log_execution_time "${FUNCNAME[0]}" $start_time
}

function dnetwork_create() {
  local start_time=$(date +%s)
  log_operation "Creating Docker network"
  docker network create "$@"
  log_execution_time "${FUNCNAME[0]}" $start_time
}

function dnetwork_connect() {
  local start_time=$(date +%s)
  log_operation "Connecting Docker container to network"
  docker network connect "$@" $(dklcid)
  log_execution_time "${FUNCNAME[0]}" $start_time
}

function dnetwork_disconnect() {
  local start_time=$(date +%s)
  log_operation "Disconnecting Docker container from network"
  docker network disconnect "$@" $(dklcid)
  log_execution_time "${FUNCNAME[0]}" $start_time
}

function dpause() {
  local start_time=$(date +%s)
  log_operation "Pausing Docker container"
  docker pause $(dklcid)
  log_execution_time "${FUNCNAME[0]}" $start_time
}

function dport() {
  local start_time=$(date +%s)
  log_operation "Listing Docker container ports"
  docker port $(dklcid)
  log_execution_time "${FUNCNAME[0]}" $start_time
}

function drename() {
  local start_time=$(date +%s)
  log_operation "Renaming Docker container"
  docker rename $(dklcid) "$@"
  log_execution_time "${FUNCNAME[0]}" $start_time
}

function dstats() {
  local start_time=$(date +%s)
  log_operation "Showing Docker container stats"
  docker stats $(dklcid)
  log_execution_time "${FUNCNAME[0]}" $start_time
}

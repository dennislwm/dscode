#!/bin/bash
##########################################################################
# Shellscript:  Backup and update WordPress using wp-cli
# Author     :  Paco Orozco <paco@pacoorozco.info>
# Requires   :  wp-cli
##########################################################################
# Changelog
# 20170125: 1.0
#       Adds a default option to upgrade only when it's needed.
# 20161220: 0.1
#       Inital release
##########################################################################

##########################################################################
# Configuration Section
##########################################################################
#


##########################################################################
# DO NOT MODIFY BEYOND THIS LINE
##########################################################################
# Program name and version
PN=$( basename "$0" )
VER='1.0'

# Script exits immediately if any command within it exits with a non-zero status.
set -o errexit
# Script will catch the exit status of a previous command in a pipe.
set -o pipefail
# Script exits immediately if tries to use an undeclared variables.
set -o nounset
# Uncomment this to enable debug
# set -o xtrace

# Get data in dd-mm-yyyy format
TIMESTAMP=$( date +"%Y%m%d-%H%M" )
# Set verbose mode
VERBOSE=false

WP_PATH=""
BACKUP_PATH=""
NUM_OF_BACKUPS=0
WP_CLI="wp --allow-root --path=/var/www/html"

##########################################################################
# Functions
##########################################################################
function warn () {
    if [ "${VERBOSE}" = true ]
    then
        if [ "$1" = "-n" ]
        then
            shift; echo -n "$@"
        else
            echo "$@"
        fi
    fi
}

function crit () {
    local ERROR=0
    [ "$1" = "-e" ] && shift; ERROR=$1; shift
    echo >&2 -e "${PN}: $@"
    [ ${ERROR} ] && exit ${ERROR}
}

function check-requirements () {
    # Check if wp-cli is installed.
    if ! hash "${WP_CLI}" 2>/dev/null ; then
        crit -e 1 "We require wp-cli.\nFor more info visit wp-cli.org or github.com/wp-cli/wp-cli/wiki."
    fi
}

function usage () {
    # Variables for formatting
    local U=$(tput smul)  # Underline
    local RU=$(tput rmul) # Remove underline
    local B=$(tput bold)  # Bold
    local N=$(tput sgr0)  # Normal
    
	cat <<-EOF
${B}Usage:${N}

    ${B}${PN}${N} -p ${U}directory${RU} [-b ${U}directory${RU}] [options]...

${B}Options:${N}

    ${B}-h${N}  Display this help message

    ${B}-v${N}  Enable verbose mode

    ${B}-p${N} ${U}directory${RU}
        Path to WordPress files. This is a required flag.

    ${B}-b${N} ${U}backup_dir${RU}
        Backup WP installation into a ${U}backup_dir${RU} before updating. Backs up
        both the database and files. Will be stored in the following format:

        ${U}backup_directory${RU}
        ├── wp-backup_YYYY-MM-DD_HH:MM:SS
        │   ├── database.sql
        │   └── files.tar.gz
        └── wp-backup...

        Without this option the script will keep backups on ${U}directory/backups${RU}.

    ${B}-n${N} ${U}number${RU}
        Number of backups to keep if ${B}-b${N} is specified. Useful to keep the
        backups directory clean, in case this script is run as a cron job.
        Without this option the script will keep unlimited backups.

    ${B}-w${N}  Generate a wxr (WordPress Extended RSS) file if ${B}-b${N} is specified.
        This file contains all your posts and is useful if you want to
        quickly migrate to wordpress.com. Otherwise it is redundant as the
        ${B}-b${N} option already exports your database.

${B}Examples:${N}

    ${PN} ${B}-p${N} ${U}/var/www/wp${RU}
        Minimal options. Will update WordPress installation in the specified
        directory. Will backup in /var/www/wp/backups.

    ${PN} ${B}-p${N} ${U}/var/www/wp${RU} ${B}-b${N} ${U}~/backups${RU} ${B}-n${N} ${U}5${RU}
        Same as above but now if there are old backups in the backups directory
        the script will clean it up leaving only the 5 most recent ones.
        If there are less than 5 backups, then nothing will happen.

EOF
}

function backup () {
    local BACKUP_PATH_TIMESTAMP="${BACKUP_PATH}/wp-backup_${TIMESTAMP}"
    echo "Backing up ${BACKUP_PATH_TIMESTAMP}"
    
    mkdir -p ${BACKUP_PATH_TIMESTAMP}
    ${WP_CLI} db export ${BACKUP_PATH_TIMESTAMP}/database.sql
    tar czf ${BACKUP_PATH_TIMESTAMP}/files.tar.gz ${WP_PATH} 2>/dev/null
    if [ "${WXR}" = true ] ; then
        ${WP_CLI} export --dir=${BACKUP_PATH_TIMESTAMP}
    fi
    ${WP_CLI} plugin list >> ${BACKUP_PATH_TIMESTAMP}/plugin.txt
}

function update () {
    ${WP_CLI} core update
    ${WP_CLI} plugin update --all
    ${WP_CLI} theme update --all
}

function exit_if_update_is_not_needed () {
    local NEED_CORE_UPDATE=$( ${WP_CLI} core check-update --format=count )
    local NEED_PLUGIN_UPDATE=$( ${WP_CLI} plugin list --update=available --format=count )
    
    if [ -z "${NEED_CORE_UPDATE}" ] && [ "${NEED_PLUGIN_UPDATE}" = "0" ] ; then
        warn "This WordPress site is updated. Nothing to do."
        exit 0
    fi
    
    warn "There are some updates available."
}

function cleanup () {
    if [ "${NUM_OF_BACKUPS}" -gt "0" ] ; then
        ls -td ${BACKUP_PATH}/* | awk -v n=${NUM_OF_BACKUPS} 'NR>n' | xargs -r rm -r
    fi
}

##########################################################################
# Main
##########################################################################

# Resetting OPTIND is necessary if getopts was used previously in the script.
OPTIND=1

# Process command line options
while getopts ":hvwp:b:n:" opt; do
    case $opt in
        h)
            usage
        ;;
        p)
            WP_PATH=${OPTARG}
        ;;
        b)
            BACKUP_PATH=${OPTARG}
        ;;
        n)
            if [ ! $( echo ${OPTARG} | egrep ^[[:digit:]]+$ ) ] ; then
                crit -e 1 "Bad number of backups to keep"
            else
                NUM_OF_BACKUPS=${OPTARG}
            fi
        ;;
        w)
            WXR=true
        ;;
        v)
            VERBOSE=true
        ;;
        ?)
            crit -e 1 "Invalid option: -${OPTARG}"
        ;;
        :)
            crit -e 1 "Option -${OPTARG} requires and arguement"
        ;;
    esac
done
# Shift off the options and optional --.
shift "$((OPTIND - 1))"

# Run appropriate functions based on options provided
if [ -z "${WP_PATH}" ] ; then
    usage
    exit 1
fi

# Set a default Backup path if it hasn't beed defined
BACKUP_PATH="${BACKUP_PATH:-${WP_PATH}/backups}"

# Set the wp-cli command with WP path
WP_CLI="wp --allow-root --path=${WP_PATH}"

check-requirements
echo "Check Done"

# We need to update someting.
backup
echo "Backup Done"

cleanup
echo "Cleanup Done"

# Checks if WordPress update is needed.
exit_if_update_is_not_needed
update
echo "Update Done"

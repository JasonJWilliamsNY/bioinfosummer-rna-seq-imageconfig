#!/bin/bash -x

# irsync script
#
# This script will copy the datasets and notebooks into the Atmosphere image
# at boot
main ()
{
    #
    # This is the main function -- These lines will be executed each run
    #
    inject_atmo_vars
    init_irods
    copy_workshop_datasets
}

copy_workshop_datasets ()
{
irsync -rs i:/iplant/home/shared/cyverse_training/tutorials/advanced_kallisto_and_single_cell/ /scratch/docker-persistant/tutorial-data >/irods_dataxfer.log 2>&1
ln -s /docker-persistant/tutorial-data /scratch/docker-persistant/tutorial-data
chown -R $ATMO_USER /scratch/docker-persistant/tutorial-data
chown -R $ATMO_USER /docker-persistant/tutorial-data
}
inject_atmo_vars ()
{
    #
    #
    # NOTE: For now, only $ATMO_USER will be provided to script templates (In addition to the standard 'env')
    #
    #

    # Source the .bashrc -- this contains $ATMO_USER
    PS1='HACK to avoid early-exit in .bashrc'
    . ~/.bashrc
    if [ -z "$ATMO_USER" ]; then
        echo 'Variable $ATMO_USER is not set in .bashrc! Abort!'
        exit 1 # 1 - ATMO_USER is not set!
    fi
    echo "Found user: $ATMO_USER"
}

init_irods ()
{
	if [ ! -d "$HOME/.irods" ]; then
		mkdir -p $HOME/.irods
	fi

	if [ ! -e "$HOME/.irods/irods_environment.json" ]; then
		cat << EOF > $HOME/.irods/irods_environment.json
{
    "irods_host": "data.iplantcollaborative.org",
    "irods_zone_name": "iplant",
    "irods_port": 1247,
    "irods_user_name": "anonymous"
}
EOF
	fi

}
# This line will start the execution of the script
main

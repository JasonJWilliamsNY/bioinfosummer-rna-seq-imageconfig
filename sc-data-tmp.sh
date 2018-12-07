#!/bin/bash -x

# irsync script
#
main ()
{
    #
    # This is the main function -- These lines will be executed each run
    #

    init_irods
    copy_workshop_datasets
}

copy_workshop_datasets ()
{

mkdir /docker-persistant/tutorial-data
irsync -rs i:/iplant/home/shared/cyverse_training/tutorials/advanced_kallisto_and_single_cell/ /docker-persistant/tutorial-data >/irods_dataxfer.log 2>&1

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

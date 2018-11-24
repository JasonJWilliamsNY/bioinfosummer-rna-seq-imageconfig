#!/bin/bash -x

# irsync script
#
main ()
{
    #
    # This is the main function -- These lines will be executed each run
    #

    init_irods
    copy_dc_home_datasets
}

copy_dc_home_datasets ()
{
  # Performs an irsync command to copy a test dataset folder to $ATMO_USER
  # desktop
  mkdir /tutorial-data
  irsync -rs i:/iplant/home/shared/cyverse_training/tutorials/kallisto_single_cell_tutorial /tutorial-data >/irods_dataxfer.log 2>&1
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

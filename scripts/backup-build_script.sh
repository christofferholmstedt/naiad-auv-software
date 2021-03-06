#!/bin/bash

# Build script for Project Naiad
# Written by Per-Erik Måhl, Sep 2013

# Usage: ./build_script <folder>
# Where <folder> is the main folder containing all the folders
# with all the projects.

function BuildProject
{
	gnatmake -d "-P$@" -p
}

function FindTestHarness
{
	if [[ -f "./obj/gnattest/harness/test_driver.gpr" ]]; then
		echo $(pwd)/obj/gnattest/harness/test_driver.gpr
		return 0
	fi
	return 1
}

function GatherProjects
{
	oldIFS=$IFS
	IFS=$'\n'
	content=$(ls -1 --color=never)
	gpr_file=$(pwd)/$(echo $content | grep -o *.gpr)
	results=""


	if [[ -f "${gpr_file}" ]]; then
		test_driver=$(FindTestHarness)
		if [ $? -ne 0 ]; then
			echo "ERROR: Couldn't find test-driver for $gpr_file" >&2
			return 1
		fi
		results="$gpr_file"
		#echo $gpr_file
		#return 0
	fi

	for dir in $content
	do
		if [[ -d "$(pwd)/$dir" ]] && [ "$dir" != "gnattest" ]; then
			cd "${dir}"
			projects_gathered="$(GatherProjects)"
			if [ "$results" != "" ]; then
				results="$results"$'\n'
			fi
			results="$results$projects_gathered"

			cd ..
			if [ $? -eq 1 ]; then
				return 1
			fi
		fi
	done

	IFS=$oldIFS
	echo "$results"
	return 0
}
usage()
{
cat << EOF
usage: $0 -s SOURCE_FOLDER -o XML|GNATTest -d ON|OFF

SOURCE_FOLDER _must_ end with a trailing slash (/)

This script runs the build script.
Outputs either GNATTest report or XML reports.

OPTIONS:
    -h      Shows this message
    -o      Output format
    -s      Source folder
    -d      Debug mode (default: off)
EOF
}

##########################################
# Entry point for script
##########################################
FORMAT=
SRC=
DEBUG=

# Some basics at the follwing page
# http://rsalveti.wordpress.com/2007/04/03/bash-parsing-arguments-with-getopts/
while getopts “hd:o:s:” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         o)
             FORMAT=$OPTARG
             ;;
         s)
             SRC=$OPTARG
             ;;
         d)
             DEBUG=$OPTARG
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

if [[ -z $FORMAT ]] || [[ -z $SRC ]] || [[ -z $DEBUG ]]
then
     usage
     exit 1
fi

main_path="$SRC"
# main_path="$@"
cd $main_path
cd ../..

#logging
now=$(date +"%m_%d_%Y_%H_%M_%S")
if [[ ! -d "$(pwd)/build_logs" ]]; then
	mkdir build_logs
fi
echo "Logging to $(pwd)/build_logs/build_$now.log..."
echo
exec > >(tee "$(pwd)/build_logs/build_$now.log")
exec 2>&1
cd $main_path

#fd for subshells
exec 5>&1

echo "Gathering projects..."
success=true
echo "INFO: SUCCESS variable set to $success (should be \"true\")"

projects=$(GatherProjects)
if [ $? -ne 0 ]; then
	echo $projects
	echo "ERROR: Couldn't gather projects."
	echo
	exit 1
fi
echo "$projects"
echo "...DONE"
echo

build_project=$(pwd)
build_project="${build_project##*/}"

cd ..


if [[ -d "./tests" ]]; then
	echo "Removing previous tests..."
	rm -rfv "$(pwd)/tests/"*
	echo "...DONE"
	echo
fi

if [[ -d "./build" ]]; then
	echo "Removing previous build..."
	rm -rfv "$(pwd)/build/"*
	echo "...DONE"
	echo
fi

# Remove previous results
rm -f $main_path../xml_results/*.xml

for proj in $projects
do

	# COPY PROJECT --------------------------------------------
	echo "Copying source for $proj..."
	proj_path="${proj%/*}"
	test_path="$(pwd)/tests/${proj_path##*$build_project/}"
	proj_name="${proj##*/}"
	proj_name="${proj_name%.*}"

	mkdir -pv "$test_path/src"
	mkdir -pv "$test_path/obj/gnattest"
	cp -rv "$proj_path/src/"* "$test_path/src"
	cp -v "$proj" "$test_path"
	cp -rv "$proj_path/obj/gnattest/"* "$test_path/obj/gnattest"
	echo "...DONE"
	echo
	# ---------------------------------------------------------
done

for proj in $projects
do
    # Get project name
    # TODO: This seems to be redundant moved from "run tests" part.
    temp_path=${proj%/*}
    project_name=${temp_path##*/}

	# COPY PROJECT --------------------------------------------
	echo "Copying source for $proj..."
	proj_path="${proj%/*}"
	test_path="$(pwd)/tests/${proj_path##*$build_project/}"
	proj_name="${proj##*/}"
	proj_name="${proj_name%.*}"

# 	mkdir -pv "$test_path/src"
# 	mkdir -pv "$test_path/obj/gnattest"
# 	cp -rv "$proj_path/src/"* "$test_path/src"
# 	cp -v "$proj" "$test_path"
# 	cp -rv "$proj_path/obj/gnattest/"* "$test_path/obj/gnattest"
# 	echo "...DONE"
# 	echo
	# ---------------------------------------------------------

	# CLEAN HARNESS -------------------------------------------
	echo "Cleaning harness for $proj..."
	test_project="$test_path/obj/gnattest/harness/test_driver.gpr"
	gprclean -r "-P$test_project" -XRUNTIME=full
	echo "...DONE"
	echo
	# ---------------------------------------------------------

	# Set Test Reporter -----------------------------
    # TODO: These scripts should take a path as input and run only for that
    # input. Both scripts now parses all files in all projects on each run.
    if [ $FORMAT == XML ]; then
        echo "INFO: Setting Test Reporter to XML output."
        /bin/bash $(pwd)/change_to_XML_reporter.sh
        echo "INFO: Test Reporter set to XML output."
    elif [ $FORMAT == GNATTest ]; then
        echo "INFO: Setting Test Reporter to GNATTest output."
        /bin/bash $(pwd)/change_to_GNATTest_reporter.sh
        echo "INFO: Test Reporter set to GNATTest output."
    fi
    # ---------------------------------------------------------

	# BUILD HARNESS -------------------------------------------
	echo "Building harness for $proj..."
	build_success=true
	gprbuild -d "-P$test_project" -XRUNTIME=full -p
	if [ $? -ne 0 ]; then
		build_success=false
		success=false
        echo "INFO: SUCCESS variable set to \"$success\" (build harness failed)"
	fi
	echo "...DONE"
	echo
	# ---------------------------------------------------------

	# RUN TESTS -----------------------------------------------

	if [ $build_success == true ]; then
        test_runner="${test_project%/*}/test_runner"

		echo "INFO: Running tests for project \"$project_name\""
        if [[ $DEBUG == "ON" ]]; then
            echo "DEBUG: Running tests for project \"$proj\""
        fi

        if [ $FORMAT == XML ]; then

            # Run test and output results as XML in project_root/xml_results
            mkdir -pv $main_path../xml_results
            $("$test_runner" > $main_path../xml_results/$project_name.xml)

            echo "INFO: Exported results to $main_path../xml_results/$project_name.xml"

        elif [ $FORMAT == GNATTest ]; then
            test_result=$("$test_runner" --passed-tests=hide | tee >(cat - >&5))

            if [ "$(echo $test_result | grep -o FAILED)" == "FAILED" ]; then
                success=false
                if [[ $DEBUG == "ON" ]]; then
                    echo "DEBUG: Project \"$proj_name\" had a test that failed."
                fi
            elif [ "$(echo $test_result | grep -o CRASHED)" == "CRASHED" ]; then
                if [[ $DEBUG == "ON" ]]; then
                    echo "DEBUG: Project \"$proj_name\" had a test that crashed."
                fi
                success=false
            fi
        fi
		echo "INFO: Test run for project \"$project_name\" finished."
		echo
	fi
	# ---------------------------------------------------------
done

if [ $success == false ]; then
	echo "ERROR: One or more tests failed/crashed."
	echo
	exit 1
fi

for proj in $projects
do
	echo "Building project $proj..."
	proj_path="${proj%/*}"
	build_path="$(pwd)/build/${proj_path##*$build_project/}"
	test_path="$(pwd)/tests/${proj_path##*$build_project/}"
	proj_name="${proj##*/}"

	mkdir -pv $build_path

	
	gnatmake -d "-P$test_path/$proj_name"
	cp -v "$test_path/obj/"* "$build_path" 2>/dev/null

	echo "...DONE"
	echo
done

echo "[$(date +%m-%d-%Y) $(date +%H:%M:%S)] Build successful."
echo
exit 0

#!/bin/bash

command_discovery() {
  type "$1" > /dev/null 2> /dev/null
  if ! type "$1" > /dev/null 2> /dev/null; then
    echo "\`$1\` command not found"
    exit 1
  fi
}

command_discovery awk
command_discovery shuf


SUBJECTS_DIR="subjects"

usage() {
    echo "Usage: $0 <command>"
    echo "Commands:"
    echo "  local           Run the entire local test suite"
    echo "  test -l|--language <lang>    Run the test for a specific language"
    exit 1
}

validate_folder() {
    if [ ! -d "$SUBJECTS_DIR/$1" ]; then
        echo "Error: Language folder '$1' not found in '$SUBJECTS_DIR' directory."
        exit 1
    fi
}


run_program() {
    if [ "$#" -ne 3 ]; then
        echo "Error: Invalid number of arguments. Usage: compare_command_output <command> <input> <output>"
        return 2
    fi

    local command="$1"
    local input="$2"
    local expected_output="$3"


    if [ "${SUPPRESS_ERROR}" = "false" ]; then
        actual_output=$(echo "$input" | $command)
    else
        actual_output=$(echo "$input" | $command 2>/dev/null)
    fi

    local status=$?

    if [ "$status" -eq 0 ]; then
        if [ "$actual_output" = "$expected_output" ]; then
            return 0
        else
            return 1
        fi
    else
        return 2
    fi
}

if [ "$#" -lt 1 ]; then
    usage
fi

case "$1" in
    "local")
        echo "## Local Testing Report"
        echo
        # shellcheck disable=2012
        ls $SUBJECTS_DIR \
            | while read -r name; do
            echo "### Running test - $name";
            echo
            echo "\`\`\`"

            if ! bash command.sh test -l "$name"; then
                echo "Something went wrong while testing $name..."
            fi
            echo "\`\`\`"
            echo
        done
        ;;

    "test")
        shift
        case "$1" in
            "-l" | "--language")
                if [ -z "$2" ]; then
                    echo "Error: Language argument is missing for the 'test' command."
                    usage
                fi
                language="$2"
                validate_folder "$language"

                cd $SUBJECTS_DIR/"$language" || exit
                # shellcheck disable=1091
                source .env


                if [ "${SUPPRESS_ERROR}" = "true" ]; then
                    $BUILD
                else
                    $BUILD 2>/dev/null
                fi

                total_cases=0
                success_cases=0
                error_cases=0
                failure_cases=0

                declare -A failed_cases
                declare -A errored_cases

                { time \
                        while read -r input output; do
                        # shellcheck disable=2153
                        run_program "$COMMAND" "$input" "$output";
                        case "$?" in
                            0)
                                ((success_cases++))
                                ;;
                            1)
                                failed_cases["$input"]=$output;
                                ((failure_cases++))
                                ;;
                            2)
                                errored_cases["$input"]=$output;
                                ((error_cases++))
                                ;;
                        esac
                        ((total_cases++))
                    done <\
                        <(
                        cat \
                            <(awk '{ print $1 " Ok" }' < ../../testcases/good) \
                            <(awk '{print $1 " Failed"}' < ../../testcases/bad) \
                            | shuf
                    )
                    } 2>&1

                    echo

                    for input in "${!failed_cases[@]}"; do
                        output="${failed_cases[$input]}"
                        echo "Failed case with input: $input and expected output: $output"
                    done


                    for input in "${!errored_cases[@]}"; do
                        output="${errored_cases[$input]}"
                        echo "Errored case with input: $input and expected output: $output"
                    done

                    success_rate=$(awk "BEGIN {print ($success_cases / $total_cases) * 100}")
                    failure_rate=$(awk "BEGIN {print ($failure_cases / $total_cases) * 100}")
                      error_rate=$(awk "BEGIN {print ($error_cases / $total_cases) * 100}")


                    echo "Success Rate: $success_rate%"
                    echo "Failure Rate: $failure_rate%"
                    echo "Error Rate: $error_rate%"


                    ;;

                *)
                    echo "Error: Invalid argument for 'test' command."
                    usage
                    ;;
            esac
            ;;

        *)
            usage
            ;;
    esac

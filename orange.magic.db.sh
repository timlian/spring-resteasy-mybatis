#!/bin/bash

function orange.magic.db.manage.usage()
{
    echo "Orange magic database manage"
    echo ""
    echo "Usage: "`basename $0`" [OPTION]..."
    echo ""
    echo "DESCRIPTION:"
    echo "  Database management."
    echo ""
    echo "OPTIONS:"
    echo "  -a, --action      Specify the action. Supported actions are: 'init' and 'clear' ."
    echo "  -d, --database    Specify the database name"
    echo "  -h, --help        Display help information."
    echo ""
}

function orange.magic.db.throw()
{
    local MESSAGE="$1"
    echo "${MESSAGE}"
    exit 1
}

function orange.magic.db.property.get()
{
    local KEY="$1"
    local FILE="$2"
    grep '^'"${KEY}"' \?= \?.*$' < "${FILE}" | sed 's/^'"${KEY}"' \?= \?"\?\([^"]*\)"\?$/\1/g'
}

function orange.magic.db.manage.init()
{
    echo "CREATE DATABASE ${DATABASE_NAME}" | mysql -u"${DATABASE_USERNAME}" -p"${DATABASE_PASSWORD}"
    cat schema.sql | mysql -u"${DATABASE_USERNAME}" -p"${DATABASE_PASSWORD}" "${DATABASE_NAME}"
}

function orange.magic.db.manage.clear()
{
    echo "DROP DATABASE ${DATABASE_NAME}" | mysql -u"${DATABASE_USERNAME}" -p"${DATABASE_PASSWORD}"
}

function orange.magic.db.manage.delegatebyaction()
{
    local ACTION="${1}"
    local FUNCTIONNAME="${FUNCNAME[1]}"
    [ "function" == "$(type -t "${FUNCTIONNAME}.${ACTION}")" ] || orange.magic.db.throw "Unable to execute the action: ${ACTION}"
    shift
    ${FUNCTIONNAME}.${ACTION} "$@"
}

function orange.magic.db.manage()
{
    orange.magic.db.manage.delegatebyaction "$@"
}

function main()
{
    if [ $# -eq 0 ]; then
        orange.magic.db.manage.usage
        exit 1
    fi
    while [ -n "${1:-""}" ]
    do
        case "$1" in
                -h | --help)
                        orange.magic.db.manage.usage
                        exit 0
                        ;;
                -a | --action)
                        shift
                        ACTION="${1:-""}"
                        ;;
                -d | --database)
                        shift
                        DATABASE_NAME="${1:-""}"
                        ;;
                * )
                        echo "Invalid parameter '$1', please type '-h' or '--help' for usage"
                        exit 1
                        ;;
        esac
        shift
    done
    if [ -z "${ACTION}" ];then
        echo "No action is specified, please type '-h' or '--help' for usage"
        exit 1
    fi
    DATABASE_USERNAME="$(orange.magic.db.property.get 'javax.persistence.jdbc.user'     'src/main/resources/app.jpa.properties')"
    DATABASE_PASSWORD="$(orange.magic.db.property.get 'javax.persistence.jdbc.password' 'src/main/resources/app.jpa.properties')"
    orange.magic.db.manage "${ACTION}"
}

main "$@"


#!/bin/bash

cd "$(dirname $0)" # root of translatable sources
BASEDIR="$(pwd)"

BUGADDR="https://github.com/audoban/PlayBar2"	# MSGID-Bugs
PACKAGENAME="PlayBar2"
COPYRIGHT="GPLv3"

function ki18n_xgettext
{
    TMPDIR="$BASEDIR/po/tmp"

    WDIR="../../" # working dir
    PROJECTNAME="$2" # project name
    TEMPLATE=$3 # desktop template
    PROJECTPATH="../../$1" # project path
    PROJECTPATH2= #extra project path
    TARGET="\e[0;32m$1\e[0m" #target name

    mkdir "$TMPDIR"
    cd "$TMPDIR"

    echo -e "-- Preparing rc files for $TARGET"
    find "${PROJECTPATH}" -name '*.rc' -o -name '*.ui' -o -name '*.kcfg' | sort > "${WDIR}/rcfiles.list"
    xargs --no-run-if-empty --arg-file="${WDIR}/rcfiles.list" extractrc > "${WDIR}/rc.cpp"
    echo "${WDIR}rc.cpp" > "${WDIR}/infiles.list"
    echo -e "-- Done preparing rc files for $TARGET"

    echo -e "-- Extracting messages for $TARGET"
    find "${PROJECTPATH}" -name '*.cpp' -o -name '*.h' -o -name '*.c' -o -name '*.qml' -o -name '*.qml.cmake' | sort >> "${WDIR}/infiles.list"

    xgettext --from-code=UTF-8 -L JavaScript -kde -ci18n -ki18n:1 -ki18nc:1c,2 -ki18np:1,2 -ki18ncp:1c,2,3 \
    -ktr2i18n:1 -kI18N_NOOP:1 -kI18N_NOOP2:1c,2  -kN_:1 -kaliasLocale -kki18n:1 -kki18nc:1c,2 \
    -kki18np:1,2 -kki18ncp:1c,2,3 \
    --msgid-bugs-address="${BUGADDR}" --copyright-holder="${COPYRIGHT}" --package-name="${PACKAGENAME}" \
    --files-from="${WDIR}/infiles.list" \
    -D "${TMPDIR}" -o "${WDIR}/${PROJECTNAME}.pot" || \
    { echo "error while calling xgettext. aborting."; exit 1; }

    #xgettext --from-code=UTF-8 --language=Desktop --join-existing --msgid-bugs-address="${BUGADDR}" \
    #-k -kName -kGenericName -kComment \
    #"${WDIR}/" -o "${WDIR}/${PROJECTNAME}.pot" || \
    #{ echo "error while calling xgettext. aborting."; exit 1; }

    cd "$WDIR"

    echo -e "-- Merging translations for $TARGET"
    catalogs=$(find "." -name "${PROJECTNAME}.po")
    for cat in $catalogs; do
        echo "${cat}"
        msgmerge -o "${cat}.new" "${cat}" "${PROJECTNAME}.pot"
        mv "${cat}.new" "${cat}"
    done
    echo -e "-- Done merging translations for $TARGET"

    echo "-- Cleaning up"
    rm "rcfiles.list"
    rm "infiles.list"
    rm "rc.cpp"

    echo -e "-- Done translations for $TARGET\n\n"
    rm -d "$BASEDIR/po/tmp"
}

ki18n_xgettext engine   'plasma_engine_playbar'
ki18n_xgettext plasmoid 'plasma_applet_audoban.applet.playbar'

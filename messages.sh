#!/bin/bash
shopt -s extglob

help="\n
-add-language <LANGUAGE>\n
-u, -update-pot\n
-c, -compile-po"

if [ -z "$1" ] ; then
    echo -e $help ; exit
fi

xgettext="xgettext -ki18n -C"
extractrc="extractrc"

locale_dir='./plasmoid/locale'
output_po="$locale_dir/template/LC_MESSAGES/messages.po"
output_pot=$output_po't'
pot_dir=$locale_dir'/template/LC_MESSAGES'
playbar_mo='plasma_applet_playbar.mo'
playbar_po='playbar.po'
input_files=(./plasmoid/contents/{ui,code}/*.*)
locales=($locale_dir/*/LC_MESSAGES)
rc='./plasmoid/contents/ui/rc.js'

if [ $1 == '-add-language' ] && [ -n $2  ] ; then
   mkdir -p $locale_dir/$2/LC_MESSAGES
   cp $output_pot $locale_dir/$2/LC_MESSAGES/$playbar_po
   exit
fi

if [ $1 == '-u' ] || [ $1 == '-update-pot' ] ; then
    echo "input files: " ${input_files[@]}
    $extractrc './plasmoid/contents/ui/config.ui' > $rc
    $xgettext -o "$output_po" ${input_files[@]} $rc
    mv $output_po $output_pot

	for d in ${locales[@]} ; do
		if [ $d == $pot_dir ]
			then continue
		fi
		msgmerge -o $d/$playbar_po $d/$playbar_po $output_pot
	done
	exit
fi

if [ $1 == '-c' ] || [ $1 == '-compile-po' ] ; then
    for d in $locale_dir/* ; do
		if [ $d == $locale_dir'/template' ]
			then continue
		fi
        echo "Building $d/LC_MESSAGES/playbar.mo ..."
        msgfmt "$d/LC_MESSAGES/$playbar_po" -o "$d/LC_MESSAGES/$playbar_mo"
    done
fi

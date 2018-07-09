#!/bin/ksh

script_dir="$(cd "$(dirname $0)" && pwd)"
project_dir="$(basename ${script_dir})"

cd "${script_dir}/.."

if  [ ! -L "Podfile"  ]; then

	ln -s "${project_dir}/Podfile" Podfile

fi

#if  [ ! -L "ipa.sh"  ]; then

#ln -s "${project_dir}/ipa.sh" ipa.sh

#fi

pod update --no-repo-update --verbose


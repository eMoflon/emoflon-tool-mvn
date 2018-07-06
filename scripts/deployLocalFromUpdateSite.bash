#!/bin/bash

# This script installs the desired Maven artifacts from the given update sites
#
# By convention, 
# (i)  all artifacts will by in the group $DEFAULT_GROUP_ID
# (ii) the artifact ID is equal to the bundle name
# (iii)the aritfact version is equal to the bundle version
#
# Only bundles whose ID/name occurs in the list 'bundlesToInstall' will be deployed.
#
# Author: Roland Kluge
# Date: 2018-03-19
#
# See also
# Maven install-file https://maven.apache.org/guides/mini/guide-3rd-party-jars-local.html
# Bash patterns: http://wiki.bash-hackers.org/syntax/pe
#

DEFAULT_GROUP_ID=moflon

if [ -z "$1" ];
then
  echo "Usage: $0 [comma-seperated-list-of-update-site-paths]"
  echo "Example 1 (if you have checked out the eMoflon::TIE and eMoflon::Core development projects side-by-side with this repository):"
  echo "$0 \"../../emoflon-tool/org.moflon.deployment.updatesite/,../../../../MoflonCoreDev/git/emoflon-core-updatesite/stable/updatesite\""
  echo "Example 2 (if you have checked out eMoflon.github.io side-by-side with this repository):"
  echo "$0 \"../../eMoflon.github.io/eclipse-plugin/beta/updatesite\""  
  exit 1
fi

# Relative paths to the update sites that shall be searched for bundles
#updateSiteLocations=(../../emoflon-tool/org.moflon.deployment.updatesite/ ../../../../MoflonCoreDev/git/emoflon-core-updatesite/stable/updatesite)
declare -a updateSiteLocations
IFS=',' read -r -a updateSiteLocations <<< "$1"


# Target Maven repository where jars shall be installed
repositoryLocation=../releases

# The names of the bundles to be installed (whitespace separated)
bundlesToInstall="MocaTree SDMLanguage org.moflon.core.utilities org.moflon.tgg.runtime org.moflon.tgg.language"

if [ ! -d "$repositoryLocation" ];
then
  echo "Target repo does not exist $repositoryLocation"
  exit 1
fi

for updateSiteLocation in ${updateSiteLocations[@]}; do
  if [ ! -d  "$updateSiteLocation/plugins" ];
  then
    echo "Cannot find 'plugins' folder in $updateSiteLocation"
    exit 1
  fi
done

for updateSiteLocation in ${updateSiteLocations[@]}; do
  for pluginFile in $updateSiteLocation/plugins/*;
  do
    fileName=$(basename $pluginFile)
    bundleName=${fileName%_*.jar}
    
    searchResult=$(echo $bundlesToInstall | grep "$bundleName" )
    [ "$searchResult" == "" ] && continue
    
    groupId=$DEFAULT_GROUP_ID
    artifactId=$bundleName
    version=${fileName##*_}
    version=${version%.jar}
    mvn install:install-file \
      -DlocalRepositoryPath=$repositoryLocation \
      -DperformRelease=true -DcreateChecksum=true \
      -Dfile=$pluginFile \
      -DgroupId=$groupId \
      -DartifactId=$artifactId \
      -Dversion=$version \
      -Dpackaging=jar
      
    if [ "$?" != "0" ];
    then
      echo "Installation failed for $fileName"
      exit 1
    fi
  done
done

echo "Done."
echo "Do not forget to commit and push this repository."

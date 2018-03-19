#!/bin/bash

# This script installs the desired Maven artifacts from the given update sites
#
# By convention, 
# (i)  all artifacts will by in the group $DEFAULT_GROUP_ID
# (ii) the artifact ID is equal to the bundle name
# (iii)the aritfact version is equal to the bundle version
#
# Author: Roland Kluge
# Date: 2018-03-19
#
# See also
# Maven install-file https://maven.apache.org/guides/mini/guide-3rd-party-jars-local.html
# Bash patterns: http://wiki.bash-hackers.org/syntax/pe
#

DEFAULT_GROUP_ID=moflon

# Relative paths to the update sites that shall be searched for bundles
declare -a updateSiteLocations
updateSiteLocations=(../../emoflon-tool/org.moflon.deployment.updatesite/ ../../../../MoflonCoreDev/git/emoflon-core-updatesite/stable/updatesite)

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
    
    groupId=DEFAULT_GROUP_ID
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

echo "Done. Do not forget to push."

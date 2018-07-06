#Maven repository for eMoflon::TIE

This is a Maven repository for providing selected eMoflon::TIE artifacts.
If you need additional artifacts, please contact us via the issue tracker or contact AT emoflon DOT org.

### How to use obtain eMoflon Maven artifacts (for eMoflon users)

Use the following snippet in your *pom.xml*:
```
<repositories>
    <repository>
        <id>emoflon-mvn-releases</id>
        <url>https://github.com/eMoflon/emoflon-tool-mvn/raw/master/releases</url>
    </repository>
</repositories>
```

### How to use deploy eMoflon Maven artifacts (for eMoflon developers)

The script in *scripts/deployLocalFromUpdateSite.bash* scans a list of update site locations for the desired bundles.

Basic usage:
```
cd scripts
bash ./deployLocalFromUpdateSite.bash "../../emoflon-tool/org.moflon.deployment.updatesite/,../../../../MoflonCoreDev/git/emoflon-core-updatesite/stable/updatesite"
```

See the documentation inside the script for more details.

## Credits
Thanks to Chas Emerick for the nice tutorial: https://cemerick.com/2010/08/24/hosting-maven-repos-on-github/

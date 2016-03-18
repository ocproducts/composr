#!/bin/bash

echo 'Note the build-config.js that can be used to download the latest CKEditor version';

echo 'Make sure data/ckeditor/plugins/{composr|imagepaste|spellchecktoggle|showcomcodeblocks} is preserved'

echo 'Manually download and place moono and moonocolor skins which we like to also bundle, place in skins/';

echo "Removing unneeded files"
rm -rf CHANGES.md samples _source ckeditor.pack config.js adapters

echo "Converting line endings"
find . -name "*.js" -exec dos2unix {} \;
find . -name "*.css" -exec dos2unix {} \;
find . -name "*.html" -exec dos2unix {} \;
find . -name "*.txt" -exec dos2unix {} \;
find . -name "*.md" -exec dos2unix {} \;
dos2unix .htaccess

echo "Adding byte order marks"
find . -name "*.js" -exec bom_add {} \;

echo "Done!"

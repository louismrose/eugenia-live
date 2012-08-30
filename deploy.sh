echo "Building static application with Hem"
node_modules/hem/bin/hem build
echo "Copying static application to local copy of Epsilon website"
cp -R public/* ~/Websites/MAMP/epsilon/eugenia-live
echo "Now do a CVS commit with Eclipse"

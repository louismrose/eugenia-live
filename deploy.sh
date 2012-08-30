echo "Building static application with Hem"
node_modules/hem/bin/hem build
git add public/application.{css,js}
git commit -m "Building for deployment"
echo "Pushing to Heroku"
git push heroku

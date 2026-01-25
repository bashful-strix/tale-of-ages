#!/bin/sh

npm run build
npm run bundle
mv dist/index.html dist/200.html
npx surge --domain https://tale-of-ages.surge.sh dist

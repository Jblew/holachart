npm --prefix=.. run build
cp ../dist/holachart.min.js dist.min.js
cp ../dist/holachart.min.js.map dist.min.js.map
docker run --rm -v `pwd`:/usr/share/nginx/html:ro -p 8080:80 nginx
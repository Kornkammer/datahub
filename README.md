# datahub

-------------

```

git clone git@github.com:Kornkammer/datahub.git && cd datahub
npm install
docker build . -t hub
docker run -d -it --name hub -v $PWD:/app -p 4444:4444 hub
curl localhost:4444/korns.csv

```

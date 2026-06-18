# fabrication du container sur pc :
```
./singularity-hpc.sh

```
# lancement sur belenos
seul le noeud de login 0 contient singularity et aussi les noeuds de calcul.
```
ssh belenoslogin0
singularity shell --bind /scratch:/scratch ubuntu:26.04-hpc.sif
>SSL_CERT_FILE=/home/gmap/mrpa/auger/certificats/tls-ca-bundle.pem
>export REQUESTS_CA_BUNDLE=$SSL_CERT_FILE
```
test du certificat sous python
```
python3 - <<'EOF'
import urllib.request
print(urllib.request.urlopen("https://install.python-poetry.org").status)
EOF
```

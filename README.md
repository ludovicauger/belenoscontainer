## Building container on local PC :
```
./singularity-hpc.sh

```
## Launching on belenos
Only belenoslogin0 and compuational nodes contain singularity
```
ssh belenoslogin0
singularity shell --bind /scratch:/scratch ubuntu:26.04-hpc.sif
SSL_CERT_FILE=/home/gmap/mrpa/auger/certificats/tls-ca-bundle.pem
export REQUESTS_CA_BUNDLE=$SSL_CERT_FILE
```
test du certificat sous python
```
python3 - <<'EOF'
import urllib.request
print(urllib.request.urlopen("https://install.python-poetry.org").status)
EOF
```

This part is not working because git-remote-https seems to be broken 
```
cd /scratch/work/auger/tactus_singularity/tactus
curl -k https://install.python-poetry.org | python3 -
export PATH=/home/gmap/mrpa/auger/.local/bin/:$PATH
python3 -m pip install . --break-system
```
testing git with https !
```
git ls-remote https://github.com/git/git.git
```
workaround
```
git config --global http.sslVerify false
```
currently tactus is installed during the container process creation
and the installation process goes to the end

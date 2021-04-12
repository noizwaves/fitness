## Loft + minikube cluster configuration

This describes how to deploy Loft onto a minikube-based k8s cluster for use on a local network.

In summary, the cluster:
-   is inside a VM that is bridged to the local network (which gives it a dedicated IP address)
-   exposes the nginx-ingress ports 80 and 443 on the host to enable easy ingress
-   resolvable by network DNS overrides
-   is issued SSL certificates by Let's Encrypt using Cloudflare DNS solver

### 1. Create Minikube cluster

1.  Install Minikube and Virtual Box
1.  Configure Minikube (thanks [dpb587](https://dpb587.me/post/2020/04/11/minikube-and-bridged-networking/)):
    1.  `$ minikube config set cpus 4`
    1.  `$ minikube config set disk-size 65536`
    1.  `$ minikube config set memory 16384`
    1.  `$ minikube config set vm-driver virtualbox`
1.  Start cluster via `$ minikube start`
1.  Stop cluster vis `$ minikube stop`
1.  Give minikube VM an IP on the network by:
    1.   Open Virtual Box application
    1.   Select the minikube VM
    1.   Open Settings
    1.   Add a new network interface attached to `Bridged Adapter`
    1.   Start Minikube again via `$ minikube start`
    1.   SSH into Minikube VM via `$ minikube ssh`
    1.   Read off network IP address via `$ ip addr` as `$MINIKUBE_IP`
    1.   Leave vm via `$ exit`
1.  In your local network DNS settings (i.e. Pihole, `/etc/hosts`) add record that resolves `loft.noizwaves.cloud` to `$MINIKUBE_IP`

### 2. Configure Minikube cluster

We need to ensure that the local network DNS server is the only server used.

1.  SSH into minikube via `$ minikube ssh`
1.  Disable DHCP-based DNS configuration on eth2 by creating `/etc/systemd/network/11-eth2.network` with contents
    ```
    [Match]
    Name=eth2

    [Network]
    DHCP=ipv4
    DNS=192.168.1.232

    [DHCP]
    UseDNS=false
    ```
1.  Restart networking system by:
    1.  `$ sudo systemctl daemon-reload`
    1.  `$ sudo systemctl restart systemd-networkd`
    1.  `$ sudo systemctl restart systemd-resolved`

### 3. Install ingress-nginx

1.  Install ingress-nginx by running:
    ```
    $ helm install ingress-nginx ingress-nginx \
      --repo https://kubernetes.github.io/ingress-nginx \
      --namespace ingress-nginx \
      --create-namespace \
      -f cluster/ingress-nginx/values.yaml
    ```

### 4. Install cert-manager

1.  Install cert-manager by running:
    ```
    $ helm install cert-manager cert-manager \
      --repo https://charts.jetstack.io \
      --namespace cert-manager \
      --create-namespace \
      -f cluster/cert-manager/values.yaml
    ```

### 5. Install Loft

1.  Download `loft` CLI [by](https://loft.sh/docs/quickstart#1-download-loft-cli):
    1.  `$ curl -s -L "https://github.com/loft-sh/loft/releases/latest" | sed -nE 's!.*"([^"]*loft-linux-amd64)".*!https://github.com\1!p' | xargs -n 1 curl -L -o loft && chmod +x loft;`
    1.  `$ sudo mv loft /usr/local/bin;`
1.  Install Loft via `$ loft start`
    1.  Select local cluster (or connect via port-forwarding)
    1.  Once complete, use port forwarding to log into Loft
    1.  **Note the username and password**
1.  Create Cloudflare API token secret via:
    ```
    $ kubectl create secret generic cloudflare-api-token-secret \
      --from-literal=api-token=${CLOUDFLARE_API_TOKEN} \
      --namespace loft
    ```
1.  Enable cert-issuer and ingress via:
    ```
    $ helm upgrade loft loft \
      --repo https://charts.devspace.sh/ \
      --namespace loft \
      --reuse-values \
      -f cluster/loft/values.yaml
    ```

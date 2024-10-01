Steps to Set Up StatefulSet with Default Storage Class
Install Local Path Provisioner in KIND (if not installed already): This will allow you to dynamically provision storage for the StatefulSet.

bash
Copy code
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
Verify Storage Class: After applying the Local Path Provisioner, verify the storage class:

bash
Copy code
kubectl get storageclass
You should see the local-path as the default storage class.

StatefulSet YAML Example: Here's a basic example of a StatefulSet using the default local-path storage class for persistent storage.

yaml
Copy code
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
spec:
  serviceName: "nginx"
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
        volumeMounts:
        - name: www
          mountPath: /usr/share/nginx/html
  volumeClaimTemplates:
  - metadata:
      name: www
    spec:
      accessModes: ["ReadWriteOnce"]
      storageClassName: "local-path"
      resources:
        requests:
          storage: 1Gi
Explanation:
StatefulSet: This StatefulSet creates 3 replicas of an NGINX pod, each with its own persistent storage.
volumeClaimTemplates: This section requests persistent storage for each replica, using the default local-path storage class.
storageClassName: The local-path storage class dynamically provisions persistent volumes.
Persistent Storage: Each pod in the StatefulSet gets its own unique volume claim.
Apply the StatefulSet: Save the above YAML to a file, e.g., statefulset.yaml, and apply it:

bash
Copy code
kubectl apply -f statefulset.yaml
Check the StatefulSet and PVCs: After applying, check the status of the StatefulSet and PVCs:

bash
Copy code
kubectl get statefulset
kubectl get pvc
You should see the web StatefulSet with its 3 replicas, and the corresponding persistent volume claims being created dynamically using the default storage class.

Verify Pods: You can also check the created pods using:

bash
Copy code
kubectl get pods -l app=nginx
This setup demonstrates how a StatefulSet with dynamic storage provisioning can work in a KIND cluster on Mac.

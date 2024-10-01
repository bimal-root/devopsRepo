Testing curl to product page from minikube ssh did work initially.
However,once the mTLS peer authentication yaml was applied using mode as STRICT, the same curl connection failed because, minikube ssh environment does not have istio sidecar proxy and its internal traffic is NOT encrypted using mtLS.

=========

READ: 

why accessing the product page from minikube ssh did not work after applying the peer-authentication mTLS with STRICT mode in short
ChatGPT said:
ChatGPT
When you applied the PeerAuthentication policy with STRICT mode for mTLS, accessing the productpage service from Minikube via SSH didn't work because Minikube's internal traffic (like from minikube ssh) is not encrypted using mTLS.

Key Reasons in Short:
mTLS Enforcement in STRICT Mode:
In STRICT mode, all communication between services in the Istio service mesh must be secured with mTLS. Any traffic that isn't encrypted (like plain HTTP requests from Minikube) will be rejected.
No Istio Sidecar in Minikube SSH:
The minikube ssh environment doesn't have an Istio sidecar proxy, so it can't establish an mTLS connection. Without the sidecar, the traffic from Minikube is plaintext, and mTLS will block it.
Workaround:
Use a pod inside the mesh (with Istio sidecar) to access the productpage service, or set PeerAuthentication to PERMISSIVE mode, which allows both mTLS and plaintext traffic.
Let me know if you need further clarification!

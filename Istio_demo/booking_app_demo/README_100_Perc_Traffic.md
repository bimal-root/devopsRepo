In Istio, you can use VirtualService and DestinationRule objects to control traffic between services and route traffic to specific versions of a microservice. In the Bookinfo demo, let's focus on the scenario where the Productpage service talks only to the Reviews v1 service (version 1 of the Reviews service).

Objective:
The goal is to configure Istio so that the Productpage service always communicates with the Reviews v1 service, and not with the other versions (v2 or v3).

Step-by-Step Explanation
1. The Current Setup
In the Bookinfo app:

The Productpage service calls the Reviews service.
The Reviews service has three versions (v1, v2, v3):
v1: Doesn't call the Ratings service.
v2: Calls the Ratings service and displays black star ratings.
v3: Calls the Ratings service and displays red star ratings.
Without any Istio configuration, the Productpage service could randomly send traffic to any of these three versions of the Reviews service. Our goal is to direct 100% of the traffic from the Productpage service to the Reviews v1 pod.

2. Using VirtualService to Route Traffic to Reviews v1
To achieve this, we need to create an Istio VirtualService that tells Istio to route all traffic to version v1 of the Reviews service. This is done by matching traffic going to the Reviews service and routing it to the v1 subset (which we will define in a DestinationRule).

Here’s what the VirtualService configuration looks like:

yaml
Copy code
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: reviews
spec:
  hosts:
  - reviews
  http:
  - route:
    - destination:
        host: reviews
        subset: v1
hosts: The service name (reviews). This is the target of the Productpage's service requests.
route: Defines where the traffic should go. In this case, we route all the traffic to the Reviews service's v1 subset.
3. Using DestinationRule to Define the Subsets
In Istio, subsets are versions of a service defined by labels. The DestinationRule object tells Istio which pods belong to each subset. In this case, we'll define a subset for v1 of the Reviews service.

Here’s the DestinationRule that defines the subset v1:

yaml
Copy code
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: reviews
spec:
  host: reviews
  subsets:
  - name: v1
    labels:
      version: v1
host: This matches the name of the Reviews service.
subsets: Defines different subsets (versions) of the Reviews service. Here, we're defining a v1 subset, which includes the pods with the label version: v1.
This rule essentially tells Istio that any pod with the label version: v1 belongs to the v1 subset of the Reviews service.

4. Applying the Configuration
To enforce that the Productpage service only talks to Reviews v1, you need to apply both the VirtualService and DestinationRule to the Kubernetes cluster.

You can do this by running the following commands:

bash
Copy code
kubectl apply -f virtual-service-reviews-v1.yaml
kubectl apply -f destination-rule-reviews.yaml
Where:

virtual-service-reviews-v1.yaml contains the VirtualService configuration.
destination-rule-reviews.yaml contains the DestinationRule configuration.
5. End Result
After applying these configurations, the Istio service mesh will ensure that:

All requests from the Productpage service to the Reviews service are routed exclusively to v1 of the Reviews service.
The Productpage service will never communicate with v2 or v3 of the Reviews service.
In summary, traffic is routed as follows:

rust
Copy code
Productpage -> Reviews v1
The other versions (v2 and v3) of Reviews will not receive any traffic.

How Istio Achieves This
VirtualService: Handles traffic routing decisions, ensuring that all traffic meant for the Reviews service is directed to a specific subset (v1).
DestinationRule: Defines the subsets for the Reviews service, allowing Istio to differentiate between versions (v1, v2, and v3) based on the labels assigned to the pods.
By combining these two objects, Istio effectively manages how traffic flows between services and their different versions, allowing for fine-grained control, like directing traffic to specific service versions.

Testing the Configuration
Once you've applied the configuration, you can test it by accessing the Productpage UI or making requests directly to the Productpage service. You should observe that:

The reviews section does not show any star ratings because it's using Reviews v1, which does not call the Ratings service.
You can verify the configuration by viewing the Istio dashboard (using Kiali or similar tools) to check the traffic routing in real-time.

Conclusion
In this example, you achieved the goal of routing 100% of traffic from the Productpage service to version v1 of the Reviews service by using:

VirtualService: To route traffic exclusively to the v1 subset of the Reviews service.
DestinationRule: To define the subsets (versions) of the Reviews service, enabling traffic routing based on labels.
This is a basic use case of Istio's powerful traffic management capabilities.

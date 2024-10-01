In a Canary Deployment, you deploy a new version of a service alongside the existing version and gradually shift traffic from the old version to the new version. Istio's VirtualService and DestinationRule objects allow you to control traffic splitting between different versions of a service in a Kubernetes environment.

We’ll demonstrate a Canary Deployment using the Bookinfo example. In this scenario, we will:

Route 90% of the traffic to Reviews v1 (the stable version).
Route 10% of the traffic to Reviews v2 (the new version with star ratings).
Objective:
To implement a canary deployment, where 90% of traffic is routed to v1 of the Reviews service, and 10% of traffic is routed to v2.

Steps to Implement Canary Deployment
1. Setup the Bookinfo Application
First, deploy the Bookinfo application in your Kubernetes cluster if you haven’t already:

bash
Copy code
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.17/samples/bookinfo/platform/kube/bookinfo.yaml
Ensure that Istio's automatic sidecar injection is enabled on your namespace.

2. Create the DestinationRule
A DestinationRule defines subsets for different versions of the Reviews service. Each subset represents a version of the service. In this case, we’ll define subsets for v1 and v2 of the Reviews service.

Create a DestinationRule YAML file to define the subsets:

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
  - name: v2
    labels:
      version: v2
Apply the DestinationRule:

bash
Copy code
kubectl apply -f destination-rule-reviews.yaml
The subsets section defines two subsets: v1 and v2, based on the labels assigned to the corresponding pods.
3. Create the VirtualService for Canary Deployment
Now, you will create a VirtualService to split traffic between the two subsets (versions) of the Reviews service. In this scenario, we’ll route:

90% of the traffic to v1.
10% of the traffic to v2.
Here’s the VirtualService configuration to achieve that:

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
      weight: 90
    - destination:
        host: reviews
        subset: v2
      weight: 10
This VirtualService routes traffic between the v1 and v2 subsets of the Reviews service based on the defined weights (90% to v1, 10% to v2).

Apply the VirtualService:

bash
Copy code
kubectl apply -f virtual-service-reviews-canary.yaml
4. Testing the Canary Deployment
Once you’ve applied the VirtualService and DestinationRule, you can test the canary deployment by accessing the Productpage service. You should see:

90% of the time, the reviews section will display without star ratings (because traffic is routed to v1 of Reviews, which doesn't use Ratings).
10% of the time, the reviews section will display with black star ratings (because traffic is routed to v2 of Reviews, which calls the Ratings service).
To test this, you can refresh the Productpage several times, or run a script to send multiple requests and observe the traffic distribution.

5. Optional: Gradually Shift More Traffic to v2
Over time, you can increase the percentage of traffic going to v2 as you gain confidence in the new version. For example, to route 50% of the traffic to v2 and 50% to v1, update the VirtualService:

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
      weight: 50
    - destination:
        host: reviews
        subset: v2
      weight: 50
Apply the updated VirtualService to implement the new traffic distribution:

bash
Copy code
kubectl apply -f virtual-service-reviews-50-50.yaml
Now, traffic is evenly split between v1 and v2.

Summary
In this demo, you’ve set up a Canary Deployment using Istio, where traffic is gradually shifted from v1 to v2 of the Reviews service. This allows you to safely test the new version (v2) in production without impacting most users. Over time, you can increase the traffic to v2 as it proves to be stable.

The following Istio resources were used:

DestinationRule: To define the different versions (subsets) of the Reviews service.
VirtualService: To split traffic between the versions based on weights.
By adjusting the weights in the VirtualService, you can gradually roll out new versions of services, implementing a canary deployment strategy.

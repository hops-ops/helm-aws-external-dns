import models.io.upbound.dev.meta.v1alpha1 as metav1alpha1
import models.k8s.apimachinery.pkg.apis.meta.v1 as metav1

# ==============================================================================
# Unit tests for helm.aws ExternalDNS XRD
# ==============================================================================

_items = [
    # ==========================================================================
    # Test 1: Minimal input renders Helm ExternalDNS and Pod Identity
    # ==========================================================================
    metav1alpha1.CompositionTest {
        metadata.name = "minimal-renders-helm-and-pod-identity"
        spec = {
            compositionPath = "apis/externaldns/composition.yaml"
            xrdPath = "apis/externaldns/definition.yaml"
            timeoutSeconds = 60
            validate = False
            xr = {
                apiVersion = "helm.aws.hops.ops.com.ai/v1alpha1"
                kind = "ExternalDNS"
                metadata.name = "external-dns"
                spec = {
                    clusterName = "my-cluster"
                    aws = {
                        region = "us-east-1"
                    }
                }
            }
            assertResources = [
                {
                    apiVersion = "helm.hops.ops.com.ai/v1alpha1"
                    kind = "ExternalDNS"
                    metadata.name = "external-dns"
                    spec.clusterName = "my-cluster"
                }
                {
                    apiVersion = "aws.hops.ops.com.ai/v1alpha1"
                    kind = "PodIdentity"
                    metadata.name = "external-dns-pod-identity"
                    spec = {
                        clusterName = "my-cluster"
                        region = "us-east-1"
                        serviceAccount = {
                            name = "external-dns"
                            namespace = "external-dns"
                        }
                    }
                }
            ]
        }
    }

    # ==========================================================================
    # Test 2: Custom namespace propagates to both resources
    # ==========================================================================
    metav1alpha1.CompositionTest {
        metadata.name = "custom-namespace-propagates"
        spec = {
            compositionPath = "apis/externaldns/composition.yaml"
            xrdPath = "apis/externaldns/definition.yaml"
            timeoutSeconds = 60
            validate = False
            xr = {
                apiVersion = "helm.aws.hops.ops.com.ai/v1alpha1"
                kind = "ExternalDNS"
                metadata.name = "external-dns"
                spec = {
                    clusterName = "prod-cluster"
                    namespace = "dns-system"
                    aws = {
                        region = "us-west-2"
                        rolePrefix = "prod-"
                    }
                }
            }
            assertResources = [
                {
                    apiVersion = "helm.hops.ops.com.ai/v1alpha1"
                    kind = "ExternalDNS"
                    metadata.name = "external-dns"
                    spec.namespace = "dns-system"
                }
                {
                    apiVersion = "aws.hops.ops.com.ai/v1alpha1"
                    kind = "PodIdentity"
                    metadata.name = "external-dns-pod-identity"
                    spec = {
                        rolePrefix = "prod-"
                        serviceAccount = {
                            namespace = "dns-system"
                        }
                    }
                }
            ]
        }
    }
]

items = _items

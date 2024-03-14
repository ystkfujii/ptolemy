package k8s

import (
	"context"
	"fmt"
	"path/filepath"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/runtime"
	"k8s.io/apimachinery/pkg/runtime/schema"
	"k8s.io/client-go/dynamic"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"
	"k8s.io/client-go/util/homedir"

	serving "knative.dev/serving/pkg/apis/serving/v1"
)

type client struct {
	config *rest.Config
}

func NewClient() (*client, error) {
	home := homedir.HomeDir()
	kubeconfig := filepath.Join(home, ".kube", "config")
	config, err := clientcmd.BuildConfigFromFlags("", kubeconfig)
	if err != nil {
		return nil, err
	}

	return &client{
		config: config,
	}, nil
}

func (c *client) GetRoutes() []*serving.Route {
	dc, err := dynamic.NewForConfig(c.config)
	fmt.Println(err)
	gvr := schema.GroupVersionResource{
		Group:    "serving.knative.dev",
		Version:  "v1",
		Resource: "routes",
	}
	obs, _ := dc.Resource(gvr).Namespace("default").List(context.TODO(), metav1.ListOptions{})

	items := []*serving.Route{}
	for _, v := range obs.Items {
		r := &serving.Route{}
		_ = runtime.DefaultUnstructuredConverter.FromUnstructured(v.Object, r)
		items = append(items, r)
	}

	return items
}

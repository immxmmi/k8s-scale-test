package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

var requestCounter = prometheus.NewCounter(
	prometheus.CounterOpts{
		Name: "http_requests_total",
		Help: "Total number of HTTP requests",
	},
)

func handler(w http.ResponseWriter, r *http.Request) {
	requestCounter.Inc()
	fmt.Fprintln(w, "Hello from test app")
}

func main() {
	prometheus.MustRegister(requestCounter)

	http.HandleFunc("/", handler)
	http.Handle("/metrics", promhttp.Handler())

	log.Println("Listening on :8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
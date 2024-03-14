package main

import (
	"backend/graph"
	"fmt"
	"net"
	"net/http"
	"os"
	"time"

	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/playground"
	"github.com/go-chi/chi"
	"github.com/go-chi/cors"
)

const defaultPort = "8081"

var (
	corsOpts = cors.Options{
		AllowedOrigins: []string{"https://*", "http://*"},
		AllowedMethods: []string{"GET", "POST", "OPTIONS"},
		AllowedHeaders: []string{"*"},
	}
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = defaultPort
	}

	lis, _ := net.Listen("tcp", fmt.Sprintf(":%s", port))

	router := chi.NewRouter()
	router.Use(cors.Handler(corsOpts))

	srv := handler.NewDefaultServer(graph.NewExecutableSchema(graph.Config{Resolvers: &graph.Resolver{}}))

	router.Handle("/", playground.Handler("GraphQL playground", "/query"))
	router.Handle("/query", srv)

	s := http.Server{
		ReadHeaderTimeout: 5 * time.Second,
		Handler:           router,
	}
	if err := s.Serve(lis); err != nil {
		panic(err)
	}
	return
}

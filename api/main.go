package main

import (
	"context"
	"fmt"
	"log"
	"net"

	"github.com/daxsorbito/grpc-exam-app/server/echopb"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

type server struct{}

func (s server) Echo(ctx context.Context, req *echopb.EchoRequest) (*echopb.EchoResponse, error) {
	fmt.Printf("Echo function was invoked \n")
	message := req.GetMessage()

	res := &echopb.EchoResponse{
		Message: message + " from server",
	}

	return res, nil
}

func main() {
	fmt.Println("Running server...")

	lis, err := net.Listen("tcp", "0.0.0.0:9090")
	if err != nil {
		log.Fatalf("Failed to listen: %v", err)
	}

	s := grpc.NewServer()
	echopb.RegisterEchoServiceServer(s, &server{})

	// Register reflection service on gRPC server
	reflection.Register(s)

	if err := s.Serve(lis); err != nil {
		log.Fatalf("Failed to server: %v\n", err)
	}
}

package main

import (
	"context"
	"fmt"
	"runtime"
	"time"

	"github.com/aws/aws-lambda-go/lambda"
)

var jst = time.FixedZone("Asia/Tokyo", 9*60*60)

type Request struct {
	DryRun bool `json:"dry_run"`
}

type Response struct {
	Message   string    `json:"message"`
	Timestamp time.Time `json:"timestamp"`
}

func main() {
	lambda.Start(Handler)
}

func Handler(ctx context.Context, req Request) (Response, error) {
	fmt.Println("start version function")
	fmt.Println(req)
	version := runtime.Version()
	fmt.Println(version)
	return Response{version, time.Now().In(jst)}, nil
}

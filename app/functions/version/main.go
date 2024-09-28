package main

import (
	"context"
	"fmt"
	"runtime"
	"time"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ssm"
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
	ssmValue, err := getParameter(ctx)
	fmt.Println(ssmValue)
	return Response{ssmValue, time.Now().In(jst)}, err
}

func getParameter(ctx context.Context) (string, error) {
	cfg, err := config.LoadDefaultConfig(ctx)
	if err != nil {
		return "", err
	}

	client := ssm.NewFromConfig(cfg)
	path := "/go-lambda/gcp-key"
	decrypt := true
	params := &ssm.GetParameterInput{
		Name:           &path,
		WithDecryption: &decrypt,
	}

	res, err := client.GetParameter(ctx, params)
	if err != nil {
		return "", err
	}

	return *res.Parameter.Value, nil
}

package main

import (
	"context"
	"fmt"
	"io"
	"time"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ssm"

	"cloud.google.com/go/storage"
	"google.golang.org/api/option"
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
	fmt.Println("this is v3")
	fmt.Println(req)
	ssmValue, err := getParameter(ctx)
	if err != nil {
		return Response{}, err
	}
	fmt.Println(len(ssmValue))

	gcsValue, err := getByGcs(ctx, ssmValue)
	fmt.Println(gcsValue)
	return Response{"success", time.Now().In(jst)}, err
}

func getParameter(ctx context.Context) (string, error) {
	cfg, err := config.LoadDefaultConfig(ctx)
	if err != nil {
		return "", err
	}

	client := ssm.NewFromConfig(cfg)
	path := "/go-lambda/gcp-key"
	params := &ssm.GetParameterInput{Name: &path}

	res, err := client.GetParameter(ctx, params)
	if err != nil {
		return "", err
	}

	return *res.Parameter.Value, nil
}

func getByGcs(ctx context.Context, credential string) (string, error) {
	client, err := storage.NewClient(ctx, option.WithCredentialsJSON([]byte(credential)))
	if err != nil {
		return "", err
	}
	defer client.Close()

	obj := client.Bucket("takekou-go-lambda-access").Object("sample.txt")
	reader, err := obj.NewReader(ctx)
	if err != nil {
		return "", err
	}
	defer reader.Close()

	cont, err := io.ReadAll(reader)
	if err != nil {
		return "", err
	}

	return string(cont), nil
}

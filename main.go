package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"strings"

	"github.com/codegangsta/cli"
	"github.com/jfrog/gocmd"
	"github.com/jfrog/jfrog-client-go/utils/log"
)

func main() {
	app := cli.NewApp()
	app.Name = "goc"
	app.Usage = "Runs Go using GoCenter"
	app.Version = "1.0.3"
	args := os.Args
	app.Action = func(c *cli.Context) error {
		return goCmd(c)
	}
	err := app.Run(args)
	if err != nil {
		fmt.Println(err)
		// This is needed to support the exit status code that Go itself provides
		if strings.EqualFold(err.Error(), "exit status 1") {
			os.Exit(1)
		} else {
			os.Exit(2)
		}
	}
}

func goCmd(c *cli.Context) error {
	args := c.Args()
	// Check env first.
	url := os.Getenv("GOC_GO_CENTER_URL")
	if url == "" {
		url = "https://gocenter.io/"
	}
	if os.Getenv("GOC_QUIET") != "" {
		log.Logger.SetOutputWriter(ioutil.Discard)
		log.Logger.SetStderrWriter(ioutil.Discard)
	}
	return gocmd.RunWithFallback(args, url)
}

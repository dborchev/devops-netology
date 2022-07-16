package main

import (
	"fmt"
	"os"
)

func main() {
	fmt.Print("Enter a number in meters: ")
	var input float64
	fmt.Scanf("%f", &input)

	output := input / 0.3048

	fmt.Fprintf(os.Stdout, "\nIn feet: %+f\n", output)
}
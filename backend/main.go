package main

import (
	"backend/config"
	"backend/routes/admin"
	"fmt"
)

func main() {
	config.ConnectDB()
	r := routes.SetupRouter()

	fmt.Println("🚀 Backend server berjalan di http://localhost:8080 🚀")
	r.Run(":8080")
}

package event

import (
	"backend/config"
	"backend/models"
	"io"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func CreateEvent(c *gin.Context) {
	destinationIDStr := c.PostForm("destinationId")
	nameEvent := c.PostForm("nameevent")
	startDate := c.PostForm("start_date")
	endDate := c.PostForm("end_date")
	description := c.PostForm("description")
	startTime := c.PostForm("start_time")
	endTime := c.PostForm("end_time")
	priceStr := c.PostForm("price")
	maps := c.PostForm("maps")
	doField := c.PostForm("do")
	dontField := c.PostForm("dont")
	safety := c.PostForm("safety")
	longitudeStr := c.PostForm("longitude")
	latitudeStr := c.PostForm("latitude")

	if nameEvent == "" {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "nameevent wajib diisi",
		})
		return
	}

	var destIDPointer *uint = nil
	if destinationIDStr != "" {
		dID, convErr := strconv.Atoi(destinationIDStr)
		if convErr != nil {
			c.JSON(http.StatusBadRequest, gin.H{
				"message": "destinationId harus angka",
			})
			return
		}

		tmp := uint(dID)
		destIDPointer = &tmp
	}

	var price float64 = 0
	if priceStr != "" {
		price, _ = strconv.ParseFloat(priceStr, 64)
	}

	var longitude float64 = 0
	if longitudeStr != "" {
		longitude, _ = strconv.ParseFloat(longitudeStr, 64)
	}

	var latitude float64 = 0
	if latitudeStr != "" {
		latitude, _ = strconv.ParseFloat(latitudeStr, 64)
	}

	file, err := c.FormFile("image")
	var imageBytes []byte

	if err == nil {
		openedFile, openErr := file.Open()
		if openErr != nil {
			c.JSON(http.StatusBadRequest, gin.H{"message": "Gagal membuka file"})
			return
		}
		defer openedFile.Close()

		imageBytes, err = io.ReadAll(openedFile)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"message": "Gagal membaca file"})
			return
		}
	}

	event := models.Event{
		Name:        nameEvent,
		StartDate:   startDate,
		EndDate:     endDate,
		Description: description,
		StartTime:   startTime,
		EndTime:     endTime,
		Price:       price,
		Maps:        maps,
		Do:          doField,
		Dont:        dontField,
		Safety:      safety,
		Longitude:   longitude,
		Latitude:    latitude,
		Image:       imageBytes,
	}

	if destIDPointer != nil {
		event.DestinationID = destIDPointer
	}

	if err := config.DB.Create(&event).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": "Gagal menambahkan event",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Event berhasil ditambahkan",
		"data":    event,
	})
}

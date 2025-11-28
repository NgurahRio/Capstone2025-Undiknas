package event

import (
	"backend/config"
	"backend/models"
	"io"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func UpdateEvent(c *gin.Context) {
	id := c.Param("id")

	var event models.Event
	if err := config.DB.First(&event, "id_event = ?", id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{
			"message": "Event tidak ditemukan",
		})
		return
	}

	updated := gin.H{}

	if destStr := c.PostForm("destinationId"); destStr != "" {
		if destInt, err := strconv.Atoi(destStr); err == nil && destInt >= 0 {
			tmp := uint(destInt)
			event.DestinationID = &tmp
			updated["destinationId"] = destInt
		}
	}

	stringFields := map[string]*string{
		"nameevent":   &event.Name,
		"start_date":  &event.StartDate,
		"end_date":    &event.EndDate,
		"description": &event.Description,
		"start_time":  &event.StartTime,
		"end_time":    &event.EndTime,
		"maps":        &event.Maps,
		"do":          &event.Do,
		"dont":        &event.Dont,
		"safety":      &event.Safety,
	}

	for key, field := range stringFields {
		if val := c.PostForm(key); val != "" {
			*field = val
			updated[key] = val
		}
	}

	if priceStr := c.PostForm("price"); priceStr != "" {
		if price, err := strconv.ParseFloat(priceStr, 64); err == nil {
			event.Price = price
			updated["price"] = price
		}
	}

	if lonStr := c.PostForm("longitude"); lonStr != "" {
		if lon, err := strconv.ParseFloat(lonStr, 64); err == nil {
			event.Longitude = lon
			updated["longitude"] = lon
		}
	}

	if latStr := c.PostForm("latitude"); latStr != "" {
		if lat, err := strconv.ParseFloat(latStr, 64); err == nil {
			event.Latitude = lat
			updated["latitude"] = lat
		}
	}

	file, err := c.FormFile("image")
	if err == nil {
		f, _ := file.Open()
		defer f.Close()

		imgBytes, _ := io.ReadAll(f)
		event.Image = imgBytes

		updated["image"] = "uploaded"
	}

	if len(updated) == 0 {
		c.JSON(http.StatusOK, gin.H{
			"message": "Tidak ada perubahan",
			"data":    gin.H{},
		})
		return
	}

	if err := config.DB.Save(&event).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": "Gagal memperbarui event",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Event berhasil diperbarui",
		"data":    updated,
	})
}

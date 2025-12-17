package event

import (
	"backend/config"
	"backend/models"
	"encoding/base64"
	"encoding/json"
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
			// Validasi apakah destinationId ada di database
			var destCheck models.Destination
			if err := config.DB.First(&destCheck, "id_destination = ?", destInt).Error; err != nil {
				c.JSON(http.StatusBadRequest, gin.H{
					"message": "destinationId tidak ditemukan di database",
				})
				return
			}

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
		"location":    &event.Location,
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

	imagesBase64 := []string{}

	// Collect multiple images if provided under the same "image" field.
	if form, formErr := c.MultipartForm(); formErr == nil && form != nil {
		if files, ok := form.File["image"]; ok {
			for idx, file := range files {
				f, openErr := file.Open()
				if openErr != nil {
					c.JSON(http.StatusBadRequest, gin.H{"message": "Gagal membuka file ke-" + strconv.Itoa(idx+1)})
					return
				}

				imgBytes, readErr := io.ReadAll(f)
				f.Close()
				if readErr != nil {
					c.JSON(http.StatusBadRequest, gin.H{"message": "Gagal membaca file ke-" + strconv.Itoa(idx+1)})
					return
				}

				imagesBase64 = append(imagesBase64, base64.StdEncoding.EncodeToString(imgBytes))
			}
		}
	}

	if len(imagesBase64) == 0 {
		file, err := c.FormFile("image")
		if err == nil {
			f, openErr := file.Open()
			if openErr != nil {
				c.JSON(http.StatusBadRequest, gin.H{"message": "Gagal membuka file"})
				return
			}
			defer f.Close()

			imgBytes, readErr := io.ReadAll(f)
			if readErr != nil {
				c.JSON(http.StatusBadRequest, gin.H{"message": "Gagal membaca file"})
				return
			}

			imagesBase64 = append(imagesBase64, base64.StdEncoding.EncodeToString(imgBytes))
		} else if err != http.ErrMissingFile {
			c.JSON(http.StatusBadRequest, gin.H{"message": "Gagal mengambil file image"})
			return
		}
	}

	if len(imagesBase64) > 0 {
		jsonBytes, marshalErr := json.Marshal(imagesBase64)
		if marshalErr != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"message": "Gagal memproses image"})
			return
		}

		event.ImageEvent = string(jsonBytes)
		updated["image_event"] = "uploaded"
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

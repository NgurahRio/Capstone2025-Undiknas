package destination

import (
	"backend/config"
	"backend/models"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
)

func CreateDestination(c *gin.Context) {
	rawSubcategory := c.PostForm("subcategoryId")
	if rawSubcategory == "" {
		c.JSON(http.StatusBadRequest, gin.H{"message": "subcategoryId wajib diisi (contoh: 1,4,7)"})
		return
	}

	name := c.PostForm("namedestination")
	location := c.PostForm("location")
	description := c.PostForm("description")
	do := c.PostForm("do")
	dont := c.PostForm("dont")
	safety := c.PostForm("safety")
	maps := c.PostForm("maps")
	sosID, _ := strconv.Atoi(c.PostForm("sosId"))
	longitude, _ := strconv.ParseFloat(c.PostForm("longitude"), 64)
	latitude, _ := strconv.ParseFloat(c.PostForm("latitude"), 64)

	rawFacility := c.PostForm("facilityId")
	if rawFacility == "" {
		c.JSON(http.StatusBadRequest, gin.H{"message": "facilityId wajib diisi (contoh: 1,3,5)"})
		return
	}

	facilityIDs := strings.Split(rawFacility, ",")
	for _, idStr := range facilityIDs {
		idInt, _ := strconv.Atoi(strings.TrimSpace(idStr))

		var f models.Facility
		if err := config.DB.First(&f, "id_facility = ?", idInt).Error; err != nil {
			c.JSON(http.StatusBadRequest, gin.H{
				"message": fmt.Sprintf("Facility ID %d tidak ditemukan", idInt),
			})
			return
		}
	}

	subcategoryIDs := strings.Split(rawSubcategory, ",")
	for _, idStr := range subcategoryIDs {
		idInt, _ := strconv.Atoi(strings.TrimSpace(idStr))

		var s models.Subcategory
		if err := config.DB.First(&s, "id_subcategories = ?", idInt).Error; err != nil {
			c.JSON(http.StatusBadRequest, gin.H{
				"message": fmt.Sprintf("Subcategory ID %d tidak ditemukan", idInt),
			})
			return
		}
	}

	imagesBase64 := []string{}

	if form, formErr := c.MultipartForm(); formErr == nil && form != nil {
		if files, ok := form.File["image"]; ok {
			for idx, file := range files {
				openFile, err := file.Open()
				if err != nil {
					c.JSON(http.StatusBadRequest, gin.H{"message": fmt.Sprintf("Gagal membuka file ke-%d", idx+1)})
					return
				}

				rawBytes, readErr := io.ReadAll(openFile)
				openFile.Close()
				if readErr != nil {
					c.JSON(http.StatusBadRequest, gin.H{"message": fmt.Sprintf("Gagal membaca file ke-%d", idx+1)})
					return
				}

				imagesBase64 = append(imagesBase64, base64.StdEncoding.EncodeToString(rawBytes))
			}
		}
	}

	if len(imagesBase64) == 0 {
		c.JSON(http.StatusBadRequest, gin.H{"message": "Minimal 1 image wajib diupload"})
		return
	}

	var imageBase64 string
	if len(imagesBase64) > 0 {
		jsonBytes, marshalErr := json.Marshal(imagesBase64)
		if marshalErr != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"message": "Gagal memproses image"})
			return
		}
		imageBase64 = string(jsonBytes)
	}

	destination := models.Destination{
		SubcategoryID: rawSubcategory,
		Name:          name,
		Location:      location,
		Description:   description,
		Imagedata:     imageBase64,
		Do:            do,
		Dont:          dont,
		Safety:        safety,
		Maps:          maps,
		SosID:         uint(sosID),
		FacilityID:    rawFacility,
		Longitude:     longitude,
		Latitude:      latitude,
		CreatedAt:     time.Now().Format("2006-01-02 15:04:05"),
		UpdatedAt:     time.Now().Format("2006-01-02 15:04:05"),
	}

	if err := config.DB.Create(&destination).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": "Gagal menambahkan destinasi",
			"error":   err.Error(),
		})
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"message": "Destination berhasil ditambahkan",
		"data": gin.H{
			"destination": gin.H{
				"id_destination":  destination.ID,
				"namedestination": destination.Name,
				"location":        destination.Location,
				"description":     destination.Description,
				"images":          imagesBase64,
				"do":              destination.Do,
				"dont":            destination.Dont,
				"safety":          destination.Safety,
				"maps":            destination.Maps,
				"sosId":           destination.SosID,
				"facilityId":      destination.FacilityID,
				"subcategoryId":   destination.SubcategoryID,
				"longitude":       destination.Longitude,
				"latitude":        destination.Latitude,
				"created_at":      destination.CreatedAt,
				"updated_at":      destination.UpdatedAt,
			},
		},
	})
}

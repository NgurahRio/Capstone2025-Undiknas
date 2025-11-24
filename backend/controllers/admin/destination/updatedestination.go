package destination

import (
	"backend/config"
	"backend/models"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

// PUT /admin/destination/:id → update destination by ID
func UpdateDestination(c *gin.Context) {
	id := c.Param("id")
	var destination models.Destination

	// Check if destination exists
	if err := config.DB.First(&destination, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Destination tidak ditemukan"})
		return
	}

	// Bind input data
	var input struct {
		SubcategoryID uint   `json:"subcategoryId"`
		Name          string `json:"namedestination"`
		Location      string `json:"location"`
		Description   string `json:"description"`
		ImageURL      []byte `json:"image_url"`
		FileType      string `json:"file_type"`
		Fasilitas     string `json:"fasilitas"`
		Do            string `json:"do"`
		Dont          string `json:"dont"`
		Safety        string `json:"safety"`
		Maps          string `json:"maps"`
		SosID         uint   `json:"sosId"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Update fields
	if input.SubcategoryID != 0 {
		destination.SubcategoryID = input.SubcategoryID
	}
	if input.Name != "" {
		destination.Name = input.Name
	}
	if input.Location != "" {
		destination.Location = input.Location
	}
	if input.Description != "" {
		destination.Description = input.Description
	}
	if input.ImageURL != nil {
		destination.ImageURL = input.ImageURL
	}
	if input.FileType != "" {
		destination.FileType = input.FileType
	}
	if input.Do != "" {
		destination.Do = input.Do
	}
	if input.Dont != "" {
		destination.Dont = input.Dont
	}
	if input.Safety != "" {
		destination.Safety = input.Safety
	}
	if input.Maps != "" {
		destination.Maps = input.Maps
	}
	if input.SosID != 0 {
		destination.SosID = input.SosID
	}

	// Update timestamp
	destination.UpdatedAt = time.Now().Format("2006-01-02 15:04:05")

	// Save changes to database
	if err := config.DB.Save(&destination).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal mengupdate destination"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Destination berhasil diupdate",
		"data":    destination,
	})
}
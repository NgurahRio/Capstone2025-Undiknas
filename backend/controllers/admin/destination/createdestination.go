package destination

import (
	"backend/config"
	"backend/models"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

// POST /admin/destination → create new destination
func CreateDestination(c *gin.Context) {
	var input struct {
		SubcategoryID uint   `json:"subcategoryId" binding:"required"`
		Name          string `json:"namedestination" binding:"required"`
		Location      string `json:"location"`
		Description   string `json:"description"`
		ImageURL      []byte `json:"image_url"`
		FileType      string `json:"file_type"`
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

	destination := models.Destination{
		SubcategoryID: input.SubcategoryID,
		Name:          input.Name,
		Location:      input.Location,
		Description:   input.Description,
		ImageURL:      input.ImageURL,
		FileType:      input.FileType,
		Do:            input.Do,
		Dont:          input.Dont,
		Safety:        input.Safety,
		Maps:          input.Maps,
		SosID:         input.SosID,
		CreatedAt:     time.Now().Format("2006-01-02 15:04:05"),
		UpdatedAt:     time.Now().Format("2006-01-02 15:04:05"),
	}

	if err := config.DB.Create(&destination).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal menambahkan destination"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Destination berhasil ditambahkan",
		"data":    destination,
	})
}
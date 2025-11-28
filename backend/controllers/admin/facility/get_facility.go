package facility

import (
	"backend/config"
	"backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

func GetAllFacility(c *gin.Context) {
	var facilities []models.Facility

	if err := config.DB.Find(&facilities).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"message": "Gagal mengambil data fasilitas"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Data fasilitas berhasil diambil",
		"data":    facilities,
	})
}

func GetFacilityByID(c *gin.Context) {
	id := c.Param("id")

	var facility models.Facility
	if err := config.DB.First(&facility, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"message": "Fasilitas tidak ditemukan"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Detail fasilitas berhasil diambil",
		"data":    facility,
	})
}

func GetFacilityIcon(c *gin.Context) {
    id := c.Param("id")

    var facility models.Facility
    if err := config.DB.First(&facility, id).Error; err != nil {
        c.JSON(http.StatusNotFound, gin.H{"message": "Fasilitas tidak ditemukan"})
        return
    }

    if len(facility.Icon) == 0 {
        c.JSON(http.StatusNotFound, gin.H{"message": "Icon kosong"})
        return
    }

    var contentType string
    switch facility.FileType {
    case "png":
        contentType = "image/png"
    case "jpg", "jpeg":
        contentType = "image/jpeg"
    case "webp":
        contentType = "image/webp"
    case "svg":
        contentType = "image/svg+xml"
    default:
        contentType = "application/octet-stream"
    }

    c.Data(http.StatusOK, contentType, facility.Icon)
}

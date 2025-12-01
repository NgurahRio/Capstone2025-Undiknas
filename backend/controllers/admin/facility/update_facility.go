package facility

import (
	"backend/config"
	"backend/models"
	"io/ioutil"
	"net/http"

	"github.com/gin-gonic/gin"
)

func UpdateFacility(c *gin.Context) {
	id := c.Param("id")

	var facility models.Facility
	if err := config.DB.First(&facility, "id_facility = ?", id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"message": "Fasilitas tidak ditemukan"})
		return
	}

	nameFacility := c.PostForm("namefacility")
	fileType := c.PostForm("file_type")

	if nameFacility != "" {
		facility.NameFacility = nameFacility
	}

	if fileType != "" {
		facility.FileType = fileType
	}

	file, err := c.FormFile("icon")
	if err == nil {
		openedFile, err := file.Open()
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"message": "Gagal membuka file"})
			return
		}
		defer openedFile.Close()

		data, err := ioutil.ReadAll(openedFile)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"message": "Gagal membaca file"})
			return
		}

		facility.Icon = data
	}

	if err := config.DB.Save(&facility).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"message": "Gagal update fasilitas"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Fasilitas berhasil diperbarui",
		"data":    facility,
	})
}

package facility

import (
	"backend/config"
	"backend/models"
	"io"
	"mime/multipart"
	"net/http"
	"path/filepath"
	"strings"

	"github.com/gin-gonic/gin"
)

func getFileExtension(file *multipart.FileHeader) string {
	ext := strings.ToLower(filepath.Ext(file.Filename))
	return strings.TrimPrefix(ext, ".")
}

func isValidImage(ext string) bool {
	valid := map[string]bool{
		"png":  true,
		"jpg":  true,
		"jpeg": true,
		"webp": true,
		"svg":  true,
	}
	return valid[ext]
}

func CreateFacility(c *gin.Context) {

	nameFacility := c.PostForm("namefacility")
	if nameFacility == "" {
		c.JSON(http.StatusBadRequest, gin.H{"message": "namefacility wajib diisi"})
		return
	}

	file, err := c.FormFile("icon")
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "File icon wajib diupload"})
		return
	}

	fileType := getFileExtension(file)
	if !isValidImage(fileType) {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "Tipe file tidak valid (hanya png, jpg, jpeg, webp, svg)",
		})
		return
	}

	openedFile, err := file.Open()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"message": "Gagal membuka file"})
		return
	}
	defer openedFile.Close()

	fileBytes, err := io.ReadAll(openedFile)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"message": "Gagal membaca file"})
		return
	}

	facility := models.Facility{
		NameFacility: nameFacility,
		Icon:         fileBytes,
		FileType:     fileType,
	}

	if err := config.DB.Create(&facility).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"message": "Gagal menyimpan fasilitas"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"message": "Fasilitas berhasil ditambahkan",
		"data":    facility,
	})
}

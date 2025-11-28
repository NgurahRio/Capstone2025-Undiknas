package favorite

import (
	"backend/config"
	"backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

// AddFavorite menyimpan destinasi sebagai favorite untuk user yang terautentikasi.
func AddFavorite(c *gin.Context) {
	var input struct {
		DestinationID uint `json:"destinationId" binding:"required"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Permintaan tidak valid. destinationId diperlukan."})
		return
	}

	// Ambil user_id dari context (diset oleh middleware JWT)
	uidVal, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User tidak terautentikasi"})
		return
	}

	var userID uint
	switch v := uidVal.(type) {
	case uint:
		userID = v
	case int:
		userID = uint(v)
	case float64:
		userID = uint(v)
	default:
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Tipe user_id tidak dikenali"})
		return
	}

	// Cek apakah sudah ada favorite yang sama
	var existing models.Favorite
	if err := config.DB.Where("userId = ? AND destinationId = ?", userID, input.DestinationID).First(&existing).Error; err == nil {
		c.JSON(http.StatusConflict, gin.H{"error": "Destinasi sudah ada di favorite"})
		return
	}

	fav := models.Favorite{
		UserID:        userID,
		DestinationID: input.DestinationID,
	}

	if err := config.DB.Create(&fav).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal menyimpan favorite"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": "Favorite ditambahkan", "favorite": fav})
}
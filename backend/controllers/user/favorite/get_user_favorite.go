package favorite

import (
	"backend/config"
	"backend/models"
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
)

// GetUserFavorites mengembalikan daftar favorite (destinasi) milik user yang terautentikasi.
func GetUserFavorites(c *gin.Context) {
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

	var favorites []models.Favorite
	if err := config.DB.Where("userId = ?", userID).Find(&favorites).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal mengambil favorites"})
		return
	}

	// Kumpulkan destination IDs
	var destIDs []uint
	for _, f := range favorites {
		destIDs = append(destIDs, f.DestinationID)
	}

	var destinations []models.Destination
	if len(destIDs) > 0 {
		if err := config.DB.Where("id_destination IN ?", destIDs).Find(&destinations).Error; err != nil {
			// jangan gagal total jika gagal mengambil destinasi, kembalikan favorites saja
			fmt.Println("warning: gagal mengambil detail destinasi:", err)
		}
	}

	c.JSON(http.StatusOK, gin.H{"favorites": favorites, "destinations": destinations})
}
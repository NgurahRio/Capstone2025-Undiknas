package favorite

import (
	"backend/config"
	"backend/models"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

// DeleteFavorite menghapus favorite berdasarkan destinationId untuk user yang terautentikasi.
func DeleteFavorite(c *gin.Context) {
	// Ambil destinationId dari parameter path
	destIdStr := c.Param("destinationId")
	if destIdStr == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "destinationId diperlukan"})
		return
	}

	d, err := strconv.ParseUint(destIdStr, 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "destinationId tidak valid"})
		return
	}
	destID := uint(d)

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

	// Hapus record favorite
	if err := config.DB.Where("userId = ? AND destinationId = ?", userID, destID).Delete(&models.Favorite{}).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal menghapus favorite"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Favorite dihapus"})
}
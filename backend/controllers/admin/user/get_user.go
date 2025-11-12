package user


import (
	"net/http"
	"backend/config"
	"backend/models"

	"github.com/gin-gonic/gin"
)

// GET /admin/users → semua user
func GetAllUsers(c *gin.Context) {
	var users []models.User
	if err := config.DB.Find(&users).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal mengambil data pengguna"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Berhasil mengambil semua pengguna", "data": users})
}

// GET /admin/users/:id → user by ID
func GetUserByID(c *gin.Context) {
	id := c.Param("id")
	var user models.User
	if err := config.DB.First(&user, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Pengguna tidak ditemukan"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Berhasil mengambil data pengguna", "data": user})
}

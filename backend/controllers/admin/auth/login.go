package auth

import (
	"backend/config"
	"backend/middleware"
	"backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
)

func LoginAdmin(c *gin.Context) {
	var input struct {
		LoginID  string `json:"loginId" binding:"required"` // bisa username atau email
		Password string `json:"password" binding:"required"`
	}

	// Ambil JSON dari body
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var admin models.User

	// Cari berdasarkan username ATAU email
	if err := config.DB.Where("(username = ? OR email = ?) AND roleId = 2", input.LoginID, input.LoginID).
		First(&admin).Error; err != nil {

		c.JSON(http.StatusUnauthorized, gin.H{"error": "Akun tidak ditemukan atau bukan admin"})
		return
	}

	// Cocokkan password (bcrypt)
	if err := bcrypt.CompareHashAndPassword([]byte(admin.Password), []byte(input.Password)); err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Password salah"})
		return
	}

	// Generate JWT
	token, err := middleware.GenerateToken(admin.ID, admin.RoleID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal membuat token"})
		return
	}

	// Response
	c.JSON(http.StatusOK, gin.H{
		"message": "Login berhasil",
		"token":   token,
		"user": gin.H{
			"id_users": admin.ID,
			"username": admin.Username,
			"email":    admin.Email,
			"roleId":   admin.RoleID,
		},
	})
}

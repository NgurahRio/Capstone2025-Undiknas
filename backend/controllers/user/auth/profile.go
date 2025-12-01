package auth

import (
	"backend/config"
	"backend/models"
	"errors"
	"io"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

// maxProfileImageSize caps profile image uploads to 5MB to avoid bloating the row.
const maxProfileImageSize = 5 * 1024 * 1024

// UpdateProfile memungkinkan pengguna memperbarui username, password, dan foto profil.
// Gunakan konten multipart/form-data dengan field opsional:
// - username: string
// - password: string
// - image: file (opsional)
func UpdateProfile(c *gin.Context) {
	userIDVal, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Tidak dapat menemukan informasi pengguna"})
		return
	}

	userID, ok := userIDVal.(uint)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User ID tidak valid"})
		return
	}

	var user models.User
	if err := config.DB.First(&user, userID).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			c.JSON(http.StatusNotFound, gin.H{"error": "Pengguna tidak ditemukan"})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal mengambil data pengguna"})
		return
	}

	newUsername := strings.TrimSpace(c.PostForm("username"))
	newPassword := c.PostForm("password")
	oldPassword := c.PostForm("old_password")

	// Perbarui username jika diberikan dan belum digunakan user lain.
	if newUsername != "" && newUsername != user.Username {
		var count int64
		if err := config.DB.Model(&models.User{}).
			Where("username = ? AND id_users <> ?", newUsername, userID).
			Count(&count).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal memeriksa username"})
			return
		}
		if count > 0 {
			c.JSON(http.StatusConflict, gin.H{"error": "Username sudah digunakan"})
			return
		}
		user.Username = newUsername
	}

	// Perbarui password jika diberikan, wajib sertakan old_password yang valid.
	if newPassword != "" {
		if oldPassword == "" {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Password lama wajib diisi untuk mengganti password"})
			return
		}

		if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(oldPassword)); err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Password lama tidak sesuai"})
			return
		}

		hashed, err := bcrypt.GenerateFromPassword([]byte(newPassword), bcrypt.DefaultCost)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal mengenkripsi password baru"})
			return
		}
		user.Password = string(hashed)
	}

	// Proses upload foto profil jika ada.
	file, err := c.FormFile("image")
	if err == nil {
		if file.Size > maxProfileImageSize {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Ukuran foto terlalu besar (maksimal 5MB)"})
			return
		}

		src, err := file.Open()
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Gagal membaca foto profil"})
			return
		}
		defer src.Close()

		imgBytes, err := io.ReadAll(src)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Gagal memproses foto profil"})
			return
		}

		user.Image = imgBytes
	} else if !errors.Is(err, http.ErrMissingFile) {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Gagal mengambil file foto profil"})
		return
	}

	if err := config.DB.Save(&user).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal memperbarui profil"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Profil berhasil diperbarui",
		"user": gin.H{
			"id_users": user.ID,
			"username": user.Username,
			"email":    user.Email,
			"roleId":   user.RoleID,
			"hasImage": len(user.Image) > 0,
		},
	})
}

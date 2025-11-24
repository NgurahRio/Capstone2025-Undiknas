package facility

import (
    "backend/config"
    "backend/models"
    "net/http"

    "github.com/gin-gonic/gin"
)

func DeleteFacility(c *gin.Context) {
    id := c.Param("id")

    if err := config.DB.Delete(&models.Facility{}, "id_facility = ?", id).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }

    c.JSON(http.StatusOK, gin.H{"message": "Facility deleted successfully"})
}

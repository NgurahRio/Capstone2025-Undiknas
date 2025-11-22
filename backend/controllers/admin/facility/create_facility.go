package facility

import (
    "backend/config"
    "backend/models"
    "net/http"

    "github.com/gin-gonic/gin"
)

func CreateFacility(c *gin.Context) {
    var input models.Facility

    if err := c.ShouldBindJSON(&input); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    if err := config.DB.Create(&input).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }

    c.JSON(http.StatusOK, gin.H{
        "message":  "Facility created successfully",
        "facility": input,
    })
}

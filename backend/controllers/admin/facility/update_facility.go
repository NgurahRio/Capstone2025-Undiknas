package facility

import (
    "backend/config"
    "backend/models"
    "net/http"

    "github.com/gin-gonic/gin"
)

func UpdateFacility(c *gin.Context) {
    id := c.Param("id")

    var facility models.Facility
    if err := config.DB.First(&facility, "id_facility = ?", id).Error; err != nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "Facility not found"})
        return
    }

    var input models.Facility
    if err := c.ShouldBindJSON(&input); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    config.DB.Model(&facility).Updates(input)

    c.JSON(http.StatusOK, gin.H{
        "message":  "Facility updated successfully",
        "facility": facility,
    })
}

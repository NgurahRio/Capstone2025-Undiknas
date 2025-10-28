package models

type Favorite struct {
	ID            uint `gorm:"primaryKey;column:id_favorites" json:"id_favorites"`
	UserID        uint `gorm:"column:userId" json:"userId"`
	DestinationID uint `gorm:"column:destinationId" json:"destinationId"`
}

func (Favorite) TableName() string {
	return "favorite"
}
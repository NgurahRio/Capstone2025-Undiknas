package models

type Favorite struct {
	ID            uint `gorm:"primaryKey;column:id_bookmark" json:"id_bookmark"`
	UserID        uint `gorm:"column:userId" json:"userId"`
	DestinationID *uint `gorm:"column:destinationId" json:"destinationId"`
	EventID       *uint `gorm:"column:eventId" json:"eventId,omitempty"`
}

func (Favorite) TableName() string {
	return "bookmark"
}

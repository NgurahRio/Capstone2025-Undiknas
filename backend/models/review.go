package models

type Review struct {
	ID            uint   `gorm:"primaryKey;column:id_reviews" json:"id_reviews"`
	UserID        uint   `gorm:"column:userId" json:"userId"`
	DestinationID uint   `gorm:"column:destinationId" json:"destinationId"`
	Rating        int    `gorm:"column:rating" json:"rating"`
	Comment       string `gorm:"column:comment" json:"comment"`
	CreatedAt     string `gorm:"column:created_at" json:"created_at"`
}

func (Review) TableName() string {
	return "reviews"
}


package models

type role struct {
	ID   uint   `gorm:"primaryKey;column:id_role" json:"id_role"`
	Name string `gorm:"column:name;not null" json:"name"`
}

func (role) TableName() string {
	return "role"
}

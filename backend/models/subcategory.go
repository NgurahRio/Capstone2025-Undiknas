package models 

type SubCategory struct {
	ID           uint   `gorm:"primaryKey;column:id_subcategories" json:"id_subcategories"`
	CategoriesID uint   `gorm:"column:categoriesId;not null" json:"categoriesId"`
	Name         string `gorm:"column:namesubcategories;not null" json:"namesubcategories"`
}

func (SubCategory) TableName() string {
	return "subcategories"
}
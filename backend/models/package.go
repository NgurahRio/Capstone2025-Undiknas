package models

type Package struct {
	ID            uint    `gorm:"primaryKey;column:id_package" json:"id_package"`
	DestinationID uint    `gorm:"column:destinationId;not null" json:"destinationId"`
	PackageID     uint    `gorm:"column:packageId;not null" json:"packageId"`
	Price         float64 `gorm:"column:price" json:"price"`
}

func (Package) TableName() string {
	return "package"
}
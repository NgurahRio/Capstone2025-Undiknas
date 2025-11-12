package models

type Package struct {
	ID            uint    `gorm:"primaryKey;column:id_package" json:"id_package"`
	DestinationID uint    `gorm:"column:destinationId;not null" json:"destinationId"`
	SubPackageID  uint    `gorm:"column:subPackageId;not null" json:"subPackageId"`
	Price         float64 `gorm:"column:price" json:"price"`
	Include       string  `gorm:"column:include" json:"include"`
	NotInclude    string  `gorm:"column:notinclude" json:"notinclude"`
}

func (Package) TableName() string {
	return "package"
}

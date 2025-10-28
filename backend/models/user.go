package models

type User struct {
	ID       uint   `gorm:"primaryKey;column:id_users" json:"id_users"`
	Username string `gorm:"column:username;not null" json:"username"`
	Password string `gorm:"column:password;not null" json:"-"`
	RoleID   uint   `gorm:"column:roleId" json:"roleId"`
	Email    string `gorm:"column:email;not null" json:"email"`
}

func (User) TableName() string {
	return "user"
}
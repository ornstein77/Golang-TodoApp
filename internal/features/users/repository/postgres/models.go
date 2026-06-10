package users_postgres_repository

import (
	"github.com/google/uuid"
	"github.com/ornstein77/Golang-TodoApp/internal/core/domain"
)

type UserModel struct {
	ID          uuid.UUID
	Version     int
	FullName    string
	PhoneNumber *string
}

func userDomainsFromModels(users []UserModel) []domain.User {
	userDomains := make([]domain.User, len(users))
	for i, user := range users {
		userDomains[i] = domain.NewUser(
			user.ID,
			user.Version,
			user.FullName,
			user.PhoneNumber,
		)
	}
	return userDomains
}

package tasks_transport_http

import (
	"time"

	"github.com/google/uuid"
	"github.com/ornstein77/Golang-TodoApp/internal/core/domain"
)

type TaskDTOResponse struct {
	ID          uuid.UUID  `json:"id"  example:"550e8400-e29b-41d4-a716-446655440000"`
	Version     int        `json:"version" example:"3"`
	Title       string     `json:"title"  example:"Домашка"`
	Description *string    `json:"description" example:"Сделать до четверга домашнее задание по математике"`
	Completed   bool       `json:"completed" example:"false"`
	CreatedAt   time.Time  `json:"created_at"  example:"2026-02-26T10:30:00Z"`
	CompletedAt *time.Time `json:"completed_at" example:"null"`

	AuthorUserId uuid.UUID `json:"author_user_id" example:"550e8400-e29b-41d4-a716-446655440001"`
}

func taskDTOFromDomain(task domain.Task) TaskDTOResponse {
	return TaskDTOResponse{
		ID:           task.ID,
		Version:      task.Version,
		Title:        task.Title,
		Description:  task.Description,
		Completed:    task.Completed,
		CreatedAt:    task.CreatedAt,
		CompletedAt:  task.CompletedAt,
		AuthorUserId: task.AuthorUserID,
	}
}

func taskDTOsFromDomain(tasks []domain.Task) []TaskDTOResponse {
	dtos := make([]TaskDTOResponse, len(tasks))

	for i, task := range tasks {
		dtos[i] = taskDTOFromDomain(task)
	}
	return dtos
}

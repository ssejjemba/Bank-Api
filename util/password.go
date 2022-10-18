package util

import (
	"errors"
	"fmt"

	"github.com/alexedwards/argon2id"
)

// HashPassword returns the hash of the password
func HashPassword(password string) (string, error) {
	hashedPassword, err := argon2id.CreateHash(password, argon2id.DefaultParams)
	if err != nil {
		return "", fmt.Errorf("failed to hash password: %w", err)
	}

	return hashedPassword, nil
}

// CheckPassword checks if the provided password is correct or not.
func CheckPassword(password string, hashedPassword string) error {
	match, err := argon2id.ComparePasswordAndHash(password, hashedPassword)
	if err != nil {
		return err
	}
	if match == false {
		return errors.New("Password doesn't match")
	}

	return nil
}

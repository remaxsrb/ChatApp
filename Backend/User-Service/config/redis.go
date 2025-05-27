package config

import (
	"context"
	"github.com/redis/go-redis/v9"
	"os"
)

var Ctx = context.Background()
var RedisClient *redis.Client

func InitRedis() {
	RedisClient = redis.NewClient(&redis.Options{
		Addr:     os.Getenv("REDIS_HOST") + ":" + os.Getenv("REDIS_PORT"),
		Password: "",
		DB:       0,
	})

	_, err := RedisClient.Ping(Ctx).Result()
	if err != nil {
		panic(err)
	}
}

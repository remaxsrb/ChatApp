# Stage 1: Build the Go binary
FROM golang:1.24 AS builder

WORKDIR /app

# Copy go mod and sum files for dependency management
COPY go.mod ./
COPY go.sum ./

# Download the Go dependencies
RUN go mod download

# Copy the rest of the application source code
COPY . ./

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build -o main ./cmd/main.go

# Stage 2: Run the app
FROM alpine:latest

WORKDIR /app

# Copy the binary and .env from the builder stage
COPY --from=builder /app/main .
COPY --from=builder /app/.env .

EXPOSE 9090

CMD ["./main"]
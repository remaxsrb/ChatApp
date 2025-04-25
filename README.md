# ChatApp

This repository contains a **Chat Application** built with **Flutter** on the client side and **Go** on the server side. The server-side application is designed with a microservices architecture, where each service is single-purpose and containerized using Docker.

## Features

- **Client Side**: A responsive and feature-rich chat application built using Flutter.
- **Server Side**: A set of Dockerized microservices written in Go, each handling a specific functionality.
- **Secure Communication**: HTTPS communication is simulated locally using self-signed certificates.

## Prerequisites

Before running the application, ensure you have the following installed:

- [Flutter](https://flutter.dev/docs/get-started/install)
- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Go](https://golang.org/doc/install)
- [Android Studio](https://developer.android.com/studio) (for emulators on Windows/Linux)
- [Xcode](https://developer.apple.com/xcode/) (for emulators on macOS)

This application is built with mobile clients in mind. To run the app, you need to have Android Studio or Xcode installed to use emulators.

Additionally, run the provided `generation.sh` script in the repository to generate the necessary certificates. After running the script:

- Copy `server-cert.pem` and `server-key.pem` to `nginx/certs` on the backend.
- Copy `ca-cert.pem` to `assets/certs` in the Flutter app.

## Environment Variables

Instructions coming soon.
FROM golang:1.24.3 AS builder
WORKDIR /app/src
COPY src/ ./
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o ../keda-demo-app main.go

FROM alpine:latest
WORKDIR /
COPY --from=builder /app/keda-demo-app /
RUN chmod +x /keda-demo-app
EXPOSE 8080
CMD ["/keda-demo-app"]
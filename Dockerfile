FROM golang:1.24.3 AS builder
WORKDIR /app/src
COPY src/ ./
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o ../dummy-autoscale-app main.go

FROM alpine:latest
WORKDIR /
COPY --from=builder /app/dummy-autoscale-app /
RUN chmod +x /dummy-autoscale-app
EXPOSE 8080
CMD ["/dummy-autoscale-app"]
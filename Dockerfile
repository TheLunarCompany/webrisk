FROM golang:1.19 AS build

WORKDIR /go/src/webrisk

# Cache go.mod to pre-download dependencies
COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .

RUN CGO_ENABLED=0 go build -o /go/bin/wrserver cmd/wrserver/main.go

FROM gcr.io/distroless/static-debian11 AS wrserver

COPY --from=build /go/bin/wrserver /

# The APIKEY Environmental Variable should be passed in at runtime. Example:
# docker run -e APIKEY=XXXXXXXXXXXXXXXXXXXXX -p 8080:8080 <container label>
ENTRYPOINT [ "/wrserver"]

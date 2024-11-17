FROM alpine:latest
ENV USER MyUser
CMD ["sh", "-c", "echo Hello, $USER!"]

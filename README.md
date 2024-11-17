# Basic_Dockerfile

- Use a lightweight base image
FROM alpine:latest

- Set the default user environment variable (optional)
ENV USER Captain

- Set the command to print the user
CMD ["sh", "-c", "echo Hello, $USER!"]

## Usage
```
docker build -t my_dock .
docker run my_dock
```

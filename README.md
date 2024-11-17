# Basic_Dockerfile

1. Use a lightweight base image
- FROM alpine:latest
2. Set the default user environment variable (optional)
- ENV USER Captain
3. Set the command to print the user
- CMD ["sh", "-c", "echo Hello, $USER!"]

## Usage
```
docker build -t my_dock .
docker run my_dock
```
### URL
[link](https://github.com/Aramxxx8691/Basic_Dockerfile/tree/master)


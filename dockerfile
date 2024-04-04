FROM quay.io/projectquay/golang:1.20


COPY image_linux /app/my_image

CMD ["/app/my_image"]

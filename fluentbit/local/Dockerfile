FROM fluent/fluent-bit:2.1.9-arm64

COPY fluent-bit.conf /fluent-bit/etc/fluent-bit.conf

ENV TZ=Asia/Seoul
CMD ["/fluent-bit/bin/fluent-bit", "-c", "/fluent-bit/etc/fluent-bit.conf"]

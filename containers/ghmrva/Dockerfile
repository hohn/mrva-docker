# Thin runtime image for gh-mrva
# Binary is prebuilt inside mrva-platform and staged into the build context

FROM mrva-platform:0.4.8

# Copy prebuilt binary from build context
COPY gh-mrva /usr/local/bin/gh-mrva

# Utility container: stays alive for interactive / exec use
WORKDIR /app
CMD ["tail", "-f", "/dev/null"]

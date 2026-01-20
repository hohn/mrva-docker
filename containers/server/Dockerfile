# Thin runtime image for mrvaserver

FROM mrva-platform:0.4.7

# Copy prebuilt binary and entrypoint
COPY mrvaserver /usr/local/bin/mrvaserver
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["--mode=container"]

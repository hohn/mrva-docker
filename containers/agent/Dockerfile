# Thin runtime image for mrvaagent

FROM mrva-platform:0.4.7

# Copy prebuilt binary and entrypoint
COPY mrvaagent /usr/local/bin/mrvaagent
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

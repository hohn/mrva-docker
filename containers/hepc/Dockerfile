# Thin runtime image for mrvahepc
# Source tree is staged into the build context by the driver scripts

FROM mrva-platform:0.4.8

# Application root
WORKDIR /work-gh/mrva

# Copy pre-staged source tree
COPY mrvahepc mrvahepc

WORKDIR /work-gh/mrva/mrvahepc

# Create isolated Python environment (PEP 668–compliant)
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install --no-cache-dir -r requirements.txt && \
    /opt/venv/bin/pip install .

# Ensure the venv is used at runtime
ENV PATH=/opt/venv/bin:$PATH

# Canonical values mount
VOLUME /mrva/values
EXPOSE 8070

CMD ["hepc-serve-global", "--host", "0.0.0.0", "--port", "8070"]

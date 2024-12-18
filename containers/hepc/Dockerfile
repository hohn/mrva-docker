# Use a Python 3.11 image as the base
FROM python:3.11-slim

# Create the required directory structure
RUN mkdir -p /work-gh/mrva/

# Change to the directory and clone the repository
WORKDIR /work-gh/mrva/
COPY ./mrvahepc mrvahepc

# Change to the hepc directory
WORKDIR /work-gh/mrva/mrvahepc

# We're in a container, so use pip globally -- no virtual env
RUN pip install --upgrade pip

# Install the required Python packages from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Install hepc
RUN pip install .

# Run server
WORKDIR /work-gh/mrva/mrvahepc
CMD ["mc-hepc-serve",                           \
    "--codeql-db-dir", "db-collection.tmp",     \
    "--host", "0.0.0.0",                      \
    "--port", "8070"                            \
    ]




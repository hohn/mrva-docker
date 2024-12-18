# Use a Python 3.11 image as the base
FROM python:3.11-slim

# Install git
RUN apt-get update && apt-get install -y git

# Create the required directory structure
RUN mkdir -p /work-gh/mrva/

# Change to the directory and clone the repository
WORKDIR /work-gh/mrva/
RUN git clone https://github.com/hohn/mrvahepc.git && \
    cd mrvahepc && \
    git checkout master

# Change to the hepc directory
WORKDIR /work-gh/mrva/mrvahepc

# We're in a container, so use pip globally -- no virtual env
RUN pip install --upgrade pip

# Install the required Python packages from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Install hepc
RUN pip install .

# Run server
CMD ["mc-hepc-serve", 
    "--codeql-db-dir", "db-collection.tmp",
    "--host", "127.0.0.1",
    "--port", "8070"
    ]




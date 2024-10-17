FROM python:3.8.14-slim

# Set non-interactive mode for apt
ARG DEBIAN_FRONTEND=noninteractive

# Force unbuffered stdout/stderr for easier debugging
ENV PYTHONUNBUFFERED=1

# Create a non-root user and set the working directory
RUN apt-get -y update && \
    && apt-get -y upgrade \
    apt-get install -y --no-install-recommends build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    useradd --uid 10000 -ms /bin/bash runner

WORKDIR /home/runner/app

# Set the non-root user for the following operations
USER 10000

# Ensure Poetry is on the PATH
ENV PATH="${PATH}:/home/runner/.local/bin"

# Copy Poetry's lock and configuration files first to leverage Docker cache
COPY pyproject.toml poetry.lock ./

# Install Poetry and project dependencies
RUN pip install --no-cache-dir poetry==1.8 && \
    poetry install --no-root --only main

# Copy the rest of the project files
COPY . .

# Expose the application port (replace $PORT with a default value if necessary)
EXPOSE $PORT

# Define the entry point and default command
ENTRYPOINT ["poetry", "run"]
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "$PORT"]

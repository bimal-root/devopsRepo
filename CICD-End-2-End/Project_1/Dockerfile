# Use an official Python runtime as a parent image
FROM python:3

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file first to leverage Docker cache
COPY requirements.txt .

# Install any necessary dependencies from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Run migrations at runtime instead of during build time
# This avoids database dependency issues during build
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

# Expose the necessary port
EXPOSE 8000



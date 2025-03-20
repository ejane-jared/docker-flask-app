#syntax=docker/dockerfile:1

# Get base image (official Python image / Alpine version)
FROM python:3.13-alpine

# Switch to the working directory
WORKDIR /app

# Copy the requirements file into the image
COPY ./requirements.txt /app/requirements.txt

# Install the required dependencies listed from requirements.txt
RUN pip install -r requirements.txt

# Copy all the files from the current folder to the image (any files/extensions listed in .dockerignore will be excluded)
COPY . /app

# Expose port 5000
EXPOSE 5000

# Specifies the starting of the expression to use when starting the container
ENTRYPOINT ["python"]

# Command to run the flask application
CMD ["app.py"]

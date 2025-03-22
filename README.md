# Build and run a Flask application with Docker
The Python Flask application will print “Hello world!” when accessed via the browser.

# Table of Contents
[Instructions to build and run the Flask application](#instructions-to-build-and-run-the-flask-application)
  - [Build the Docker image](#build-the-docker-image)
  - [Run the Docker image](#run-the-docker-image)

[Documentation of the steps taken to complete this assignment](#documentation-of-the-steps-taken-to-complete-this-assignment)
  - [Prerequisites](#prerequisites)
  - [Step 1: Create the project folder](#step-1-create-the-project-folder)
  - [Step 2: Create the flask application (Create the app.py file)](#step-2-create-the-flask-application-create-the-apppy-file)
  - [Step 3 (Optional): Test running the Flask application (run app.py)](#step-3-optional-test-running-the-flask-application-run-apppy)
  - [Step 4: Create the Dockerfile](#step-4-create-the-dockerfile)
  - [Step 5: Create the requirements.txt](#step-5-create-the-requirementstxt)
  - [Step 6: Create the .dockerignore file](#step-6-create-the-dockerignore-file)
  - [Step 7: Build the Docker image](#step-7-build-the-docker-image)
  - [Step 8: Run the image in a Docker container](#step-8-run-the-image-in-a-docker-container)
  - [Step 9: View the running application](#step-9-view-the-running-application)

[Challenges](#challenges)

## Instructions to build and run the Flask application
### Build the Docker image
Clone the Git repository.
```
git clone https://github.com/ejane-jared/docker-flask-app.git
```
In the root level of the project folder, run the following command to build the docker image.
```
docker build -t flaskapp:v1 .
```
(Optional) Verify the docker image was created with the following command.
```
docker images
```

Example output of `docker images`.
```
REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
flaskapp     v1        33fc7ce77c98   2 hours ago      91.7MB
```

### Run the Docker image

```
docker run -d -p 5000:5000 flaskapp:v1
```

(Optional) Verify the container is running with the following command.
```
docker ps
```
Example output of `docker ps`.
```
CONTAINER ID   IMAGE         COMMAND           CREATED          STATUS         PORTS                    NAMES
c1392c606dda   flaskapp:v1   "python app.py"   56 minutes ago   Up 7 seconds   0.0.0.0:5000->5000/tcp   competent_ritchie
```
With the container running, you can now visit http://localhost:5000. 

Below is screenshot of the application's output: <br>
<img src="https://i.imgur.com/gV1d7gz.png" width="400" alt="Screenshot of the Hello world! output in the web browser" >
## Documentation of the steps taken to complete this assignment.

### Prerequisites
Prior to the start of the assignment, the following tools should be installed onto your machine:
- Docker: For the containerization of the application
- Python: The programming language which Flask was built upon
- pip: Python's package installer, which will be used to install Flask
- Flask: The Python-based micro web framework which the app will be created on
- (Optional) An integrated development environment (IDE) of your choice. I used Visual Studio Code (VSCode) to complete this assignment 

### Step 1: Create the project folder
Create a project folder and give it an appropriate name for this project. Example: `docker-flask-app`

Below is a preview of the folder structure of the completed project and its files:
```
docker-flask-app
  ├── app.py                  # the python flask application
  ├── Dockerfile              # contains the set of commands needed to assemble a Docker image
  ├── requirements.txt        # list of the required dependencies to run the flask app
  ├── .dockerignore           # tells Docker which files/directories to exclude when building a Docker image
  ├── .gitignore              # specifies intentionally untracked files that Git should ignore
  └── README.md
```
The following steps will guide you in creating the key files needed to build and run the Flask application with Docker.

### Step 2: Create the flask application (Create the app.py file)

In the root level of your project folder, create an `app.py` file with the following code:
```python
from flask import Flask
import os

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello, world!"

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(debug=True,host='0.0.0.0',port=port)
```

`@app.route("/")` maps the URL path / (the root URL) to the function below it (`hello()`). 

`def hello():` When someone accesses the root URL, the associated function hello() will be executed. 

`return "Hello, world!"` Returns the string "Hello, world!" as a response to the web request. 

`app.run(debug=True, host='0.0.0.0', port=port)` Starts the Flask server and allows the app to be accessible from any IP address, not just localhost. This is useful when running inside a container. The app will run on the specified port (either from the environment variable or defaulting to 5000.


### Step 3 (Optional): Test running the Flask application (run app.py)
The flask application can be ran on its own without the need for docker images or containers.

In your command line, navigate to the root of the project folder, then enter the following command:
```
python -m flask run
```
Once the command is executed, the output will show the application is running on http://127.0.0.1:5000

If you enter the url into your browser, you should see the webpage generated by the application:<br>
<img src="https://i.imgur.com/4m4GaKv.png" width="400" alt="Screenshot of the Hello world! output in the web browser" >

Navigate back to the command line, then press CTRL+C to quit running the Flask application.

### Step 4: Create the Dockerfile
A Dockerfile is a text document that contains all the commands a user could call on the command line to assemble a Docker image.

In the root level of your project folder, create a file named `Dockerfile` with the following content:
```dockerfile
# syntax=docker/dockerfile:1

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
```
`FROM python:3.13-alpine` This sets the base image for the container. python:3.13-alpine is a lightweight Linux distribution ideal for small Docker images.

`WORKDIR /app` Sets the working directory inside the container to `/app`. All subsequent commands will run relative to this directory.

`COPY ./requirements.txt /app/requirements.txt` Copies the requirements.txt file from your local machine (current project folder directory) into the container at /app/requirements.txt.

`RUN pip install -r requirements.txt` Runs the pip install command inside the container to install the dependencies listed in requirements.txt.

`COPY . /app` Copies all files from your local directory into the /app directory inside the container. Any files or directories listed in a .dockerignore file will be excluded.

`EXPOSE 5000` Informs Docker that the container listens on port 5000.

`ENTRYPOINT ["python"]` Sets the entry point of the container to the python command. When the container starts, python will always be executed first unless overridden.

`CMD ["app.py"]` Provides the default argument for the `ENTRYPOINT`. Combined with the `ENTRYPOINT`, the container will run the equivalent of the following command: `python app.py`

The following link can be used to assist in creating other commands in the dockerfile: https://docs.docker.com/reference/dockerfile/

### Step 5: Create the requirements.txt
The requirements.txt contains a list of packages or libraries needed for the project. 
For this application, we will require Flask to be specified in our requirements.txt

In command line, check the Flask version
```
flask --version
```

Example output of the `flask --version` command
https://i.imgur.com/RCTDBNG.png

In the above commandline output, the Flask version is 3.1.0. The following will be the content of the requirements.txt file:
```
Flask==[3.1.0]
```
If needed, change the version number in the requirements.txt (`Flask==[X.X.X]`) to the version of Flask you have installed (based on the output of `flask --version`).

>Alternatively, you can run the command `pip freeze > requirements.txt` while in the root of your project folder.
This command gathers all requirements for the Flask application and places it into requirements.txt

### Step 6: Create the .dockerignore file
The .dockerignore file tells Docker which files and directories to exclude when building a Docker image. 

In the root level of your project folder, create a file named `.dockerignore`

Below is an example of the contents of a .dockerignore. Note that `.venv/`, `.vscode/` were specific for my VSCode environment, and may not need to be included if you are using a different IDE:
```
README.md
.gitignore
.venv/
.vscode/
```

Common files in the .dockeringnore could be `*.md`,`.git`,`.gitignore`

### Step 7: Build the Docker image

In the root level of the project folder, run the following command to build the docker image.
```
docker build -t flaskapp:v1 .
```
(Optional) Verify the docker image was created with the following command.
```
docker images
```

Example output of `docker images`
```
REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
flaskapp     v1        33fc7ce77c98   2 hours ago      91.7MB
```

### Step 8: Run the image in a Docker container

Once the docker image has been built, enter the following command to run the docker image in a docker container
```
docker run -d -p 5000:5000 flaskapp:v1
```

(Optional) Verify the container is running with the following command
```
docker ps
```
Example output of `docker ps`.
```
CONTAINER ID   IMAGE         COMMAND           CREATED          STATUS         PORTS                    NAMES
c1392c606dda   flaskapp:v1   "python app.py"   56 minutes ago   Up 7 seconds   0.0.0.0:5000->5000/tcp   competent_ritchie
```

### Step 9: View the running application
With the container running, you can now visit http://localhost:5000 

Below is screenshot of the application's output: <br>
<img src="https://i.imgur.com/gV1d7gz.png" width="400" alt="Screenshot of the Hello world! output in the web browser" >

Done!

# Challenges
Challenge #1: VSCode ran into an import error for flask
Solution:
- flask was not installed in the Python environment currently used in VSCode.
- Ran the command `pip install flask` in the terminal of the current environment. Verified flask was installed via `flask --version`. Then double checked VSCode no longer detected the import error.

Challenge #2: VSCode showed an error with having an empty Dockerfile
Solution: Added a line of code to indicate which base image to use for the image (FROM python:3.13-alpine)

Challange #3: Docker daemon not running error in command line
- On MacOS, received this error in terminal when running the docker build command
  - `Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?`
Solution:
- Downloaded Docker Desktop App and opened it, as MacOS natively wont run with just docker installed in terminal
- Double checked docker daemon is properly running with `docker ps` command in terminal

Challenge #4: The docker container exits immediately when running the `docker run` command, no container is listed when checking with the `docker ps` command, and checking logs of the container in the Docker Desktop app shows no errors
Solution:
- Initial app.py that I had created was not suited for use in a containerized application. The application would run to completion, then exit with no errors.
- Updated app.py with `app.run` section, set host accessible on all interfaces (0.0.0.0), and bind the port to 5000
- Once the app.py was updated and changes were commited, the docker build command was executed again, as well as the docker run command with the new image, then it worked!

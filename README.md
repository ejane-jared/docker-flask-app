# Build and run a Flask application with Docker
The Python Flask application will print “Hello world!” when accessed via the browser.

## Instructions
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
```
TODO: pic of Hello, world!
```

## Documentation of the steps taken to complete this assignment.

1. Initial read through of the assignment.

2. Installed Visual Studio Code (VSCode), Python / pip, Docker, and Git. (I am using a new laptop, hence the fresh install of these tools).

3. In VSCode, a project folder was created and named docker-flask-app. Some initial files outlined in this assignment were also created:
- app.py
  - placed example code in this file from https://pypi.org/project/Flask/
- Dockerfile
- requirements.txt
- README.md
- .gitignore
  - Added this as the project in VSCode utilized a virtual environment (.venv) to run the python environment, which is for local deployment/testing purposes only.

4. A new GitHub repository was created and the project was pushed (initial commit).
- On Github, a new repository was created and the remote url was copied.
- Github user & email was configured via git terminal commands. GitHub access was authorized.
- In VSCode, used git section to add/stage files, commit with a message, and push to main branch.

5. Tested the flask application on its own (no docker, just python and localhost).
- In terminal, “python -m flask run” was entered.
- cmd output shows it was running on http://127.0.0.1:5000.
- visited the url, confirmed it works! Hello world!

6. Updated the Dockerfile.
- Used the following documentation to assist in creating the file https://docs.docker.com/reference/dockerfile/
- Changed build image to use official Python image. This would require less steps to be executed in the Dockerfile when compared to a regular linux/alpine image.
- Reordered steps so requirements.txt is copied first before being referenced during the pip install command

7. Added .dockerignore file to the project
- Specified README.md in the dockerignore file as that isn’t required for the image build

8. Updated requirements.txt with flask (`flask==3.1.0`).

9. First attempt to build the image.
- Double check docker is installed
- Entered `docker –version` command in terminal
- Entered Build command
  - ```docker build -t flaskapp:v1 . ```

10. TODO Challange #3: Docker daemon not running

11. Running the Build command again
'docker build -t flaskapp:v1 . '

Success!

12. Verified the image was built
- In terminal, enter `docker images` and checked to see if the ouput listed the image

13. Run the image in a docker container
```docker run -d -p 5000:5000 flaskapp:v1```

14. Challenge #4: docker container exits immediately, no container shows when checking with command docker ps, and checking logs of the container in Docker Desktop shows no errors
- Solution:
  - Rewrite app.py to include explicitly start the flask server, set host accessible on all interfaces (0.0.0.0), and bind the port

15. Gather all requirements for the flask app and place into requirements.txt
  In the root of the project folder, the following command was executed
```
pip freeze > requirements.txt
```

16. Fixed the app.py code to explicitly start the flask server, set host accessible on all interfaces (0.0.0.0), and bind the port

17. Rebuild and run the image 
- Rebuilt the image with the command `docker build -t flaskapp:v2`
- Ran the rebuilt image with the command `dockker run -d -p 5000:5000 flaskapp:v2`

```
docker run -d -p 5000:5000 flaskapp:v2
```

18. Navigated to http://localhost:5000, and it works!

# Challenges
Challenge #1: VSCode ran into an import error for flask
Solution:
- flask was not installed in the Python environment currently used in VSCode.
- Ran command `pip install flask` in the terminal of the current environment.

Challenge #2: VSCode showed an error with having an empty Dockerfile
Solution: Added a line of code to indicate which base image to use for the image (FROM alpine:3.14)

Challange #3: Docker daemon not running
- On MacOS, received this error in terminal when running the docker build command
- Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
Solution:
- Downloaded Docker Desktop App and run
- Alternatively: install docker-machine in terminal
- Double check docker is properly running with `docker ps` command in terminal

Challenge #4: The docker container exits immediately when running the `docker run...` command, no container is listed when checking with the `docker ps` command, and checking logs of the container in Docker Desktop shows no errors
Solution:
- Rewrote app.py to explicitly start the flask server, set host accessible on all interfaces (0.0.0.0), and bind the port to 5000
- Once the app.py was update and changes were commited, the docker build command was executed again, as well as the run command, then it worked!

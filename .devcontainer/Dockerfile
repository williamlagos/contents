# For more information, please refer to https://aka.ms/vscode-docker-python
FROM williamlagos/eos:latest

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE 1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED 1

# Install python enviroment
RUN pacman --noconfirm -Syu python python-pip

# Install pip requirements
ADD requirements.txt .
RUN python -m pip install -r requirements.txt

WORKDIR /app
ADD . /app

# Switching to a non-root user, please refer to https://aka.ms/vscode-docker-python-user-rights
# RUN useradd appuser && chown -R appuser /app
# USER appuser

# EXPOSE 8000

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
# CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
CMD gunicorn --bind 0.0.0.0:$PORT contents.wsgi 

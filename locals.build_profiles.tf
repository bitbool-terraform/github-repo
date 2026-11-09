locals {
profiles = {
    "aca" = {
        "generic" = {
            workflow = "workflows-aca/docker-deploy.yml.tftpl"
        }
        "java-spring" = {
            workflow = "workflows-aca/docker-deploy.yml.tftpl"
        }
        "react-static" = {
            workflow = "workflows-aca/node-deploy.yml.tftpl"
        }
        # "php-laravel" = {}
        # "python-gunicorn" = {}
    }
}

dockerfiles = {
        "java-spring" = "Dockerfiles/Dockerfile.java-spring"
        "react-static" = "Dockerfiles/Dockerfile.react"
        # "php-laravel" = ""
        # "python-gunicorn" = ""
}

}

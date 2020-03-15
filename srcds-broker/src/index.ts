import * as dockerode from "dockerode";

const IMAGE_NAME = "sbuggay/srcds-docker";
const IMAGE_URL = "https://github.com/sbuggay/srcds-docker.git";

const docker = new dockerode();

function startup() {
    const image = docker.getImage(IMAGE_NAME);
    console.log(image);
}

startup();


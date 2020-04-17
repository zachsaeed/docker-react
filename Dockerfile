#

# ----- Run phase
# tag this phase as builder. This FROM command and everything underneath it is going to be refered as the builder phase
FROM node:alpine as builder
WORKDIR '/app'
COPY package.json .
RUN npm install

# We dont need to setup the volume system as it is only required by the dev container when we are editing our code
COPY . .

# This will create /app/build/ that's gonna have the deployment code which we care about and will be copied into the build phase
RUN npm run build

# ----- Build phase
# using the official nginx image from docker hub
FROM nginx

# I want to copy something <from phase builder> <from directory> <to directory>. To see where to copy in nginx, look at documentation for nginx on docker hub
COPY --from=builder /app/build /usr/share/nginx/html

# We dont need a startup command to start nginx according to nginx image documentation on docker hub it is already set as default command so will run with container start

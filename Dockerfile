FROM node:lts-alpine as build

# install simple http server for serving static content
RUN npm install -g http-server

# make the 'app' folder the current working directory
WORKDIR /vue-ui

# copy both 'package.json' and 'package-lock.json' (if available)
COPY package*.json ./

# install project dependencies
RUN npm install --force

# copy project files and folders to the current working directory (i.e. 'app' folder)
COPY . .

# build app for production with minification
RUN npm run build

#CMD [ "http-server", "dist" ]

FROM nginx:alpine
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=build /vue-ui/dist /usr/share/nginx/html


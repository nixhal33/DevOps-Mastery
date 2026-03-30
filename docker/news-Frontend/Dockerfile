# This installs the node version of 20
from node:20

# Create a working directory as /newsapp
workdir /newsapp

# First copy the packages.json related files into the newsapp location
copy package*.json ./

# Now run npm install & this will install the dependencies of that package.json file into the directory
run npm install 

# Now, Copying all the react files into the directory 
copy . .

# Now run the npm run build will build and create all the static files related to the project
run npm run build

# EXPOSE tells Docker which port the container will use to listen for incoming web traffic.
expose 5173

# Running command ls -l to check what directory has been made into the file
run ls -l

# Start the Vite development server, listening on all interfaces (0.0.0.0) at port 86
cmd ["npm", "run", "dev", "--", "--host", "0.0.0.0", "--port", "86"]



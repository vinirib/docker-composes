#!/bin/bash

if [ -z "$SC_MONGODB_USER" ] || [ -z "$SC_MONGODB_PASSWORD" ] || [ -z "$ROOT_MONGODB_USER" ]|| [ -z "$ROOT_MONGODB_PASSWORD" ]; then
    echo ".env file has not set the correct variables, please check if you have variables set."
    echo "SC_MONGODB_USER is $SC_MONGODB_USER"
    echo "SC_MONGODB_PASSWORD is $SC_MONGODB_PASSWORD"
    echo "ROOT_MONGODB_USER is $ROOT_MONGODB_USER"
    echo "ROOT_MONGODB_PASSWORD is $ROOT_MONGODB_PASSWORD"
    exit 1
fi

# Initiate the replica set
mongosh mongodb://mongodb1:27017 --eval '
    rsconf = {
        _id : "rsmongo",
        members: [
            { _id: 0, host: "mongodb1:27017"}
        ]
    };
    rs.initiate(rsconf);
'

# Set default RW Concern after initiating the replica set. (do it only on local environment)
mongosh mongodb://mongodb1:27017 --eval '
    db.adminCommand({setDefaultRWConcern: 1, defaultWriteConcern: { w: 1 }});
'

# Disable journaling. (do it only on local environment)
mongosh mongodb://mongodb1:27017 --eval '
    db.adminCommand({setParameter: 1, nojournal: true});
'

# Function to wait for primary node
waitForPrimary() {
    while true; do
        IS_MASTER=$(mongosh mongodb://mongodb1:27017/admin --quiet --eval 'db.isMaster().ismaster')
        if [ "$IS_MASTER" = "true" ]; then
            echo "Primary node is ready."
            break
        fi
        echo "Waiting for primary..."
        sleep 5
    done
}

waitForPrimary

# Temp create users file
cat <<EOF > create-users.js
db.createUser({
    user: '$SC_MONGODB_USER',
    pwd: '$SC_MONGODB_PASSWORD',
    roles: [{ role: 'root', db: 'admin' }]
});
db.createUser({
    user: '$ROOT_MONGODB_USER',
    pwd: '$ROOT_MONGODB_PASSWORD',
    roles: [{ role: 'root', db: 'admin' }]
});
EOF

mongosh mongodb://mongodb1:27017/admin create-users.js
echo "MongoDB setup completed."